{ pkgs, lib, testing, ... }: with lib; with builtins; testing.makeTest (let
  ifAddress =
    address:
      mkForce [ {
        inherit address;
        prefixLength = 24;
      } ];
  baseConfig = {
    # console.keyMap = "dvorak-programmer";
    virtualisation.memorySize = 192;
    networking.useDHCP        = false;
    networking.enableIPv6     = false;
  };
  nodeAddress =
    node: interface:
      (head node.config.networking.interfaces.${interface}.ipv4.addresses).address;
  closure = node: node.config.system.build.toplevel;
  routerCfg =
    {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 1 2 3 ];
      networking.interfaces = {
        eth1.ipv4.addresses = ifAddress "10.1.1.1";
        eth2.ipv4.addresses = ifAddress "10.1.2.1";
        eth3.ipv4.addresses = ifAddress "10.1.3.1"; # nat
      };
      networking.forwarding = {
        enable = true;
        firewall.allow = [
          # forwarding between vlan 1 and 2
          { from = { addresses = [ "10.1.1.0/24" ]; }; to = { interface =   "eth2"         ; }; }
          { from = { interface =   "eth2"         ; }; to = { addresses = [ "10.1.1.0/24" ]; }; }
        ];
      };
      networking.nat = {
        enable             = true;
        # nat from vlan 3 to 1
        externalInterface  = "eth1";
        internalInterfaces = [ "eth3" ];
      };
    };
in {
  name = "forwarding";

  nodes = {
    router = {
      imports = [ routerCfg ];
    };
    routerOff = {
      imports = [ routerCfg ];
      networking.forwarding.enable = mkForce false;
    };
    host1 = { nodes, ... }: {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 1 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress "10.1.1.2";
      networking.defaultGateway = nodeAddress nodes.router "eth1";
    };
    host2 = { nodes, ... }: {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 2 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress "10.1.2.2";
      networking.defaultGateway = nodeAddress nodes.router "eth2";
    };
    host3 = { nodes, ... }: {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 3 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress "10.1.3.2";
      networking.defaultGateway = nodeAddress nodes.router "eth3";
    };
  };

  testScript =
    { nodes, ... }: ''
      def ping(to):
        return "timeout 0.2 ping -c 1 -w 1 {} >&2".format(to)

      def forwarding_works():
        with subtest("Checking forwarding works (host1 <-> host2 pings succeed)"):
          host1.succeed(ping("10.1.2.2"))
          host2.succeed(ping("10.1.1.2"))

      def forwarding_not_works():
        with subtest("Checking forwarding are not works (host1 <-> host2 pings fail)"):
          host1.fail(ping("10.1.2.2"))
          host2.fail(ping("10.1.1.2"))

      def nat_works():
        with subtest("Checking nat works (only host3 -> host1 pings succeed)"):
          host3.succeed(ping("10.1.1.2"))
          host1.fail   (ping("10.1.3.2"))
          host3.fail   (ping("10.1.2.2"))

      nodes = [router, host1, host2, host3]
      for node in nodes:
        node.start()
      for node in nodes:
        node.wait_for_unit("firewall.service") # check firewall works
        node.wait_for_unit("multi-user.target")

      with subtest("Checking default configuration"):
        forwarding_works()
        nat_works()

      with subtest("Checking switch to configuration with forwarding.enable = false"):
        router.succeed(
          "${closure nodes.routerOff}/bin/switch-to-configuration test 2>&1"
        )
        # forwarding_not_works() # nat enables forwarding
        nat_works()

      with subtest("Checking switch to configuration with forwarding.enable = false"):
        router.succeed(
          "${closure nodes.router}/bin/switch-to-configuration test 2>&1"
        )
        forwarding_works()
        nat_works()
    '';
})
