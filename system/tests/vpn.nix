# TODO check nat
{ lib, testing, ... }: with lib; with builtins; testing.makeTest (let
  vlans = {
    external = 1;
    router1  = 2;
    router2  = 3;
  };
  rootNetPrefix = "10.1";
  netPrefixes =
    (mapAttrs (_: vlanID: "${rootNetPrefix}.${toString vlanID}") vlans) //
      { vpn = "${rootNetPrefix}.4"; };
  hostsPostfixes = {
    external = {
      external =  "1";
      vpn      =  "1";
    };
    router1 = {
      external =  "2";
      router1  =  "1";
      vpn      = "11";
    };
    workstation1.router1 = "2";
    router2 = {
      external =  "3";
      router2  =  "1";
      vpn      = "21";
    };
    workstation2 = {
      router2 =  "2";
      # vpn     = "22";
    };
  };

  ip =
    networkName: hostName:
      let
        prefix  = netPrefixes.${networkName};
        postfix = hostsPostfixes.${hostName}.${networkName};
      in
        "${prefix}.${postfix}";

  ifAddress =
    address:
      mkForce [ {
        inherit address;
        prefixLength = 24;
      } ];

  vpnConfig = {
    mynixos.vpn = {
      enable = true;
      subnet = netPrefixes.vpn;
      peers  = {
        external = {
          pub  = "/kJW4qjBsrpDqzG8K2NwSmngKpc97eyGZph/vKlm9Eo=";
          priv = "6PGEBH4mwu0M4oCMFrgmzvNCE6/dLFwA0L2kmMDWClc=";
          addr = hostsPostfixes.external.vpn;
        };
        router1 = {
          pub      = "09I3JGnqjhlD8adnFMe3A/HYUaehKTpwNEGY1qgnyBc=";
          priv     = "oNIZg5eHCliLtJdc8Sl4H0uxRjUwd6s9o6UqK0m6+14=";
          addr     = hostsPostfixes.router1.vpn;
          endpoint = ip "external" "router1";
          routes   = [ "${netPrefixes.router1}.0/24" ];
        };
        router2 = {
          pub      = "TKqxgV7vZ3LKMVQOiXD1P7PZqR8limwrg8Ky414FClY=";
          priv     = "IBuf5WZ2YhrudfAWMNy0uL8FZduY1ds8IHOSe6sVInI=";
          addr     = hostsPostfixes.router2.vpn;
          endpoint = ip "external" "router2";
          routes   = [ "${netPrefixes.router2}.0/24" ];
        };
      };
    };
  };
  baseConfig = {
    console.keyMap = "dvorak-programmer";
    virtualisation.memorySize = 192;
    networking.useDHCP        = false;
    networking.enableIPv6     = false;
    sss = {
      enable = true;
      commands = {
        encrypt = "cat";
        decrypt = "cat";
      };
    };
  };

in {
  name = "vpn";

  nodes =
    {
      external =
        {
          imports = [ baseConfig vpnConfig ];
          virtualisation.vlans = [ vlans.external ];
          networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "external" "external");
        };
      router1 =
        {
          imports = [ baseConfig vpnConfig ];
          virtualisation.vlans = [ vlans.external vlans.router1 ];
          networking.interfaces = {
            eth1.ipv4.addresses = ifAddress (ip "external" "router1");
            eth2.ipv4.addresses = ifAddress (ip "router1"  "router1");
          };
        };
      workstation1 =
        {
          imports = [ baseConfig ];
          virtualisation.vlans = [ vlans.router1 ];
          networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "router1" "workstation1");
          networking.defaultGateway = (ip "router1" "router1");
        };
      router2 =
        {
          imports = [ baseConfig vpnConfig ];
          virtualisation.vlans = [ vlans.external vlans.router2 ];
          networking.interfaces = {
            eth1.ipv4.addresses = ifAddress (ip "external" "router2");
            eth2.ipv4.addresses = ifAddress (ip "router2"  "router2");
          };
        };
      workstation2 =
        {
          imports = [ baseConfig ];
          virtualisation.vlans = [ vlans.router2 ];
          networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "router2" "workstation2");
          networking.defaultGateway = (ip "router2" "router2");
        };
    };

  testScript =
    ''
      def ping(to):
        return "timeout 0.2 ping -c 1 -w 1 {} >&2".format(to)

      def traffic_to_vpn(subj):
        subj.succeed(ping("${ip "vpn" "external"}"))
        subj.succeed(ping("${ip "vpn" "router1" }"))
        subj.succeed(ping("${ip "vpn" "router2" }"))

      def traffic_to_local(subj):
        subj.succeed(ping("${ip "router1" "workstation1"}"))
        subj.succeed(ping("${ip "router2" "workstation2"}"))

      def no_traffic_to_vpn(subj):
        subj.fail(ping("${ip "vpn" "external"}"))
        subj.fail(ping("${ip "vpn" "router1" }"))
        subj.fail(ping("${ip "vpn" "router2" }"))

      start_all()

      nodes = [router1, router2, external, workstation1, workstation2]
      for node in nodes:
        node.wait_for_unit("firewall.service")
        node.wait_for_unit("multi-user.target")

      traffic_to_vpn(external)
      traffic_to_local(external)

      traffic_to_vpn(router1)
      traffic_to_local(router1)

      traffic_to_vpn(router2)
      traffic_to_local(router2)

      no_traffic_to_vpn(workstation1)
      workstation1.fail(ping("${ip "router2" "workstation2"}"))

      no_traffic_to_vpn(workstation2)
      workstation2.fail(ping("${ip "router1" "workstation1"}"))
    '';
})
