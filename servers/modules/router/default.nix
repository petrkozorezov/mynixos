{ lib, config, options, pkgs, ... }:
with lib;
{
  options = {
    zoo.router = {
      enable = mkOption {
        type        = types.bool;
        default     = false;
        description = "Will machine be configured as Zoo router.";
      };

      hostname = mkOption {
        type        = types.str;
        example     = "myrouter";
        default     = "router";
        description = "Hostname of router, will be used for network.hostname.";
      };

      domain = mkOption {
        type        = types.str;
        example     = "zoo";
        default     = "lan";
        description = "Domain of the hosts in the local network.";
      };

      uplink = {
        interface = mkOption {
          type        = types.str;
          example     = "enp3s0";
          description = "Uplink Network interface.";
        };
      };

      local = {
        ethernet.interface = mkOption {
          type        = types.str;
          example     = "enp4s0";
          description = "Ethernet network interface.";
        };

        wireless = options.services.hostapd;

        bridge.interface = mkOption {
          type        = types.str;
          default     = "br0";
          example     = "br1";
          description = "Bridge interface used to connect wifi and ethernet.";
        };

        net = mkOption {
          type        = types.str;
          example     = "192.168.2";
          default     = "192.168.1";
          description = "First octets of the local network.";
        };

        ip = mkOption {
          type        = types.str;
          example     = "1";
          default     = "1";
          description = "Lost octets of the router ip in the local network.";
        };

        hosts = mkOption {
          type = types.attrsOf (types.submodule ({ name, ... }: {
            options = {

              name = mkOption {
                example     = "mbp13";
                default     = name;
                type        = types.str;
                description = "Name of the host.";
              };

              mac = mkOption {
                example     = "ac:87:a3:0c:83:96";
                type        = types.str;
                description = "MAC address of the host.";
              };
              ip = mkOption {
                example     = "1";
                type        = types.str;
                description = "Last octets of the IP address of the host.";
              };

            };
          }));
          example = {
            mbp = {
              mac = "ac:87:a3:0c:83:96";
              ip  = "50";
            };
          };
          default     = {};
          description = "DHCP/DNS hosts.";
        };
      };

    };
  };

  imports = [
    ./dnsmasq.nix
  ];

  config =
    let
      cfg    = config.zoo.router;
      bridge = cfg.local.bridge.interface;
    in mkIf cfg.enable {

      networking = {
        hostName = cfg.hostname;
        useDHCP  = false;

        bridges."${bridge}" = {
          interfaces = [
            cfg.local.ethernet.interface
            cfg.local.wireless.interface
          ];
        };

        interfaces = {
          "${cfg.uplink.interface}" = {
            useDHCP = true;
          };
          "${bridge}" = {
            useDHCP = false;
            ipv4.addresses =
              [ {
                address      = "${cfg.local.net}.${cfg.local.ip}"; # TODO remove copy/paste
                prefixLength = 24;
              } ];
          };
        };

        nat = {
          enable             = true;
          # enableIPv6 = true;
          externalInterface  = cfg.uplink.interface;
          internalInterfaces = [ bridge ];
        };

        firewall.allowedUDPPorts = [ 51820 ];

        # wireguard.interfaces = let
        #   vpnCfg = config.zoo.secrets.vpn;
        # in {
        #   wg0 = {
        #     # Determines the IP address and subnet of the client's end of the tunnel interface.
        #     ips = [ "192.168.3.2/24" ];
        #     listenPort = 51820;
        #     privateKey = vpnCfg.router.priv;

        #     peers = [
        #       # For a client configuration, one peer entry for the server will suffice.

        #       {
        #         # Public key of the server (not a file path).
        #         publicKey = "{server public key}";

        #         # Forward all the traffic via VPN.
        #         allowedIPs = [ "0.0.0.0/0" ];
        #         # Or forward only particular subnets
        #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];

        #         # Set this to the server IP and port.
        #         endpoint = "{server ip}:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577

        #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
        #         persistentKeepalive = 25;
        #       }
        #     ];
        #   };

        # wireguard = {
        #   enable = true;
        #   interfaces = {
        #     wg0 = {
        #       ips = [
        #         "192.168.3.4/24"
        #       ];
        #       peers = [
        #         {
        #           allowedIPs = [
        #             "192.168.3.1/32"
        #           ];
        #           endpoint  = "demo.wireguard.io:12913";
        #           publicKey = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
        #         }
        #       ];
        #       privateKey = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
        #     };
        #   };
        # };

      #   wireguard.interfaces = let
      #     vpnCfg    = config.zoo.secrets.vpn;
      #     vpnSubnet = "192.168.3";
      #   in {
      #     wg0 = {
      #       ips = [ "${vpnSubnet}.1/24" ];
      #       listenPort = 51820;

      #       # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      #       # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      #       postSetup = ''
      #         ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${vpnSubnet}.0/24 -o "${cfg.uplink.interface}" -j MASQUERADE
      #       '';
      #       postShutdown = ''
      #         ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${vpnSubnet}.0/24 -o "${cfg.uplink.interface}" -j MASQUERADE
      #       '';

      #       privateKey = vpnCfg.router.priv;

      #       peers = [
      #         {
      #           publicKey = vpnCfg.mbp13.priv;
      #           # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
      #           allowedIPs = [ "${vpnSubnet}.2/32" ];
      #         }
      #       ];
      #     };
      #   };
      #   };
      # };
      };

      services.hostapd = cfg.local.wireless // {enable = true;};

      # nixos networking https://nixos.wiki/wiki/Networking
      # wifi setup https://habr.com/ru/post/315960/
      # wifi security https://habr.com/ru/post/224955/
      # WPA2-PSK-CCMP

      # services.home-assistant = {
      #   enable = true;
      #   package = pkgs.home-assistant.override {
      #     extraPackages = ps: with ps; [ colorlog ];
      #   };
      #   port = 8080;
      #   openFirewall = true;
      # };
  };
}
