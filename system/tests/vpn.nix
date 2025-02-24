# TODO check nat
{ lib, ... }: with lib; with builtins; (let
  vlans = {
    external = 1; # internet
    router1  = 2; # home network
    router2  = 3; # cloud server network
  };
  # all network have address prefixes by vlan id
  rootNetPrefix = "10.1";
  netPrefixes =
    (mapAttrs (_: vlanID: "${rootNetPrefix}.${toString vlanID}") vlans) //
      { vpn = "${rootNetPrefix}.4"; };
  # ${host}.${vlan} = postfix
  # TODO it would be better to reverse: ${vlan}.${host}
  hostsPostfixes = {
    external = {
      external1 = "1";
      external2 = "2";
      router1   = "3";
      router2   = "4";
    };
    router1 = {
      router1      = "1";
      workstation1 = "2";
    };
    router2 = {
      router2 = "1";
      workstation2 = "2";
    };
    vpn = {
      external1 = "1";
      router1   = "2";
      router2   = "3";
    };
  };

  ip =
    networkName: hostName:
      let
        prefix  = netPrefixes.${networkName};
        postfix = hostsPostfixes.${networkName}.${hostName};
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
        external1 = {
          pub  = "/kJW4qjBsrpDqzG8K2NwSmngKpc97eyGZph/vKlm9Eo=";
          priv = "6PGEBH4mwu0M4oCMFrgmzvNCE6/dLFwA0L2kmMDWClc=";
          addr = hostsPostfixes.vpn.external1;
        };
        router1 = {
          pub        = "09I3JGnqjhlD8adnFMe3A/HYUaehKTpwNEGY1qgnyBc=";
          priv       = "oNIZg5eHCliLtJdc8Sl4H0uxRjUwd6s9o6UqK0m6+14=";
          addr       = hostsPostfixes.vpn.router1;
          endpoint   = ip "external" "router1";
          allowedIPs = [ "${netPrefixes.router1}.0/24" ];
        };
        router2 = {
          pub        = "TKqxgV7vZ3LKMVQOiXD1P7PZqR8limwrg8Ky414FClY=";
          priv       = "IBuf5WZ2YhrudfAWMNy0uL8FZduY1ds8IHOSe6sVInI=";
          addr       = hostsPostfixes.vpn.router2;
          endpoint   = ip "external" "router2";
          allowedIPs = [ "${netPrefixes.router2}.0/24" ];
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

  nodes = {
    external1 = {
      imports = [ baseConfig vpnConfig ];
      virtualisation.vlans = [ vlans.external ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "external" "external1");
      networking.interfaces.eth1.ipv4.routes = [
        { address = ip "external" "external2"; prefixLength = 32; }
        { address = ip "external" "router1"  ; prefixLength = 32; }
        { address = ip "external" "router2"  ; prefixLength = 32; }
        # legal routes through vpn
        { address = "${netPrefixes.router1}.0"; prefixLength = 24; via = ip "vpn" "router1"; }
        { address = "${netPrefixes.router2}.0"; prefixLength = 24; via = ip "vpn" "router2"; }
      ];
    };
    external2 = {
      imports = [ baseConfig ];
      virtualisation.vlans = [ vlans.external ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "external" "external2");
      networking.interfaces.eth1.ipv4.routes = [
        { address = ip "external" "external1"; prefixLength = 32; }
        { address = ip "external" "router1"  ; prefixLength = 32; }
        { address = ip "external" "router2"  ; prefixLength = 32; }
        # an attempt to hack
        { address = "${netPrefixes.router1}.0"; prefixLength = 24; via = ip "external" "router1"; }
        { address = "${netPrefixes.router2}.0"; prefixLength = 24; via = ip "external" "router2"; }
      ];
    };
    router1 = {
      imports = [ baseConfig vpnConfig ];
      virtualisation.vlans = [ vlans.external vlans.router1 ];
      networking.interfaces = {
        eth1.ipv4.addresses = ifAddress (ip "external" "router1");
        eth2.ipv4.addresses = ifAddress (ip "router1"  "router1");
      };
    };
    workstation1 = {
      imports = [ baseConfig ];
      virtualisation.vlans = [ vlans.router1 ];
      networking.interfaces.eth1.ipv4.addresses = ifAddress (ip "router1" "workstation1");
      networking.defaultGateway = (ip "router1" "router1");
    };
    router2 = {
      imports = [ baseConfig vpnConfig ];
      virtualisation.vlans = [ vlans.external vlans.router2 ];
      networking.interfaces = {
        eth1.ipv4.addresses = ifAddress (ip "external" "router2");
        eth2.ipv4.addresses = ifAddress (ip "router2"  "router2");
      };
    };
    workstation2 = {
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
        subj.succeed(ping("${ip "vpn" "external1"}"))
        subj.succeed(ping("${ip "vpn" "router1" }"))
        subj.succeed(ping("${ip "vpn" "router2" }"))

      def traffic_to_external(subj):
        subj.succeed(ping("${ip "external" "external1" }"))
        subj.succeed(ping("${ip "external" "router1" }"))
        subj.succeed(ping("${ip "external" "router2" }"))

      def traffic_to_local(subj):
        subj.succeed(ping("${ip "router1" "router1"     }"))
        subj.succeed(ping("${ip "router1" "workstation1"}"))
        subj.succeed(ping("${ip "router2" "router2"     }"))
        subj.succeed(ping("${ip "router2" "workstation2"}"))

      def no_traffic_to_vpn(subj):
        subj.fail(ping("${ip "vpn" "external1"}"))
        subj.fail(ping("${ip "vpn" "router1" }"))
        subj.fail(ping("${ip "vpn" "router2" }"))

      start_all()

      nodes = [router1, router2, external1, external2, workstation1, workstation2]
      for node in nodes:
        node.wait_for_unit("firewall.service")
        node.wait_for_unit("multi-user.target")

      # TODO посмотреть, что в этом файле, и если 1 значит настройка применяется, если 2 то нет
      router1.succeed("cat /proc/sys/net/ipv4/conf/*/rp_filter")

      traffic_to_external(external1)
      traffic_to_vpn(external1)
      traffic_to_local(external1)

      traffic_to_external(external2)
      no_traffic_to_vpn(external2)
      # external2.fail(ping("${ip "router1" "router1"     }")) # BROKEN
      external2.fail(ping("${ip "router1" "workstation1"}"))
      # external2.fail(ping("${ip "router2" "router2"     }")) # BROKEN
      external2.fail(ping("${ip "router2" "workstation2"}"))

      traffic_to_external(router1)
      traffic_to_vpn(router1)
      traffic_to_local(router1)

      traffic_to_external(router2)
      traffic_to_vpn(router2)
      traffic_to_local(router2)

      no_traffic_to_vpn(workstation1)
      workstation1.fail(ping("${ip "router2" "router2"     }"))
      workstation1.fail(ping("${ip "router2" "workstation2"}"))

      no_traffic_to_vpn(workstation2)
      workstation2.fail(ping("${ip "router1" "router1"     }"))
      workstation2.fail(ping("${ip "router1" "workstation1"}"))
    '';
})
