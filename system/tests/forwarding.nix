{ pkgs, lib, testing, ... }: with lib; with builtins; testing.makeTest (let
  ifAddress =
    address:
      mkForce [ {
        inherit address;
        prefixLength = 24;
      } ];
  baseConfig = {
    console.keyMap = "dvorak-programmer";
    virtualisation.memorySize = 192;
    networking.useDHCP        = false;
    networking.enableIPv6     = false;
  };
in {
  name = "forwarding";

  nodes = {
    router = {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 1 2 ];
      networking.interfaces = {
        eth1.ipv4.addresses = ifAddress "10.1.1.1";
        eth2.ipv4.addresses = ifAddress "10.1.2.1";
      };
      networking.forwarding = {
        enable = true;
        firewall.allow = [
          { from = { interface = "eth1"       ; }; }
          { to   = { address   = "10.1.1.0/24"; }; }
        ];
      };
    };
    host1 = {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 1 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress "10.1.1.2";
      networking.defaultGateway = "10.1.1.1";
    };
    host2 = {
      imports = [ baseConfig ];
      virtualisation.vlans = [ 2 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress "10.1.2.2";
      networking.defaultGateway = "10.1.2.1";
    };
  };

  testScript =
    ''
      def ping(to):
        return "ping -c 1 {} >&2".format(to)

      start_all()

      nodes = [router, host1, host2]
      for node in nodes:
        node.wait_for_unit("firewall.service")
        node.wait_for_unit("multi-user.target")

      router.succeed(ping("10.1.1.2"))
      router.succeed(ping("10.1.2.2"))
      host1.succeed(ping("10.1.2.2"))
      host2.succeed(ping("10.1.1.2"))
    '';
})
