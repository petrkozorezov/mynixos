{ lib, config, pkgs, ... }:
with lib;
{
  options = {
    zoo.router = {
      enable = mkEnableOption "Will machine be configured as Zoo router.";

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
          description = "Network interface used for uplink communication.";
        };
      };

      local = {
        interface = mkOption {
          type        = types.str;
          example     = "enp4s0";
          description = "Network interface used for uplink communication.";
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
          default     = [];
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
      cfg = config.zoo.router;
    in mkIf cfg.enable {

      networking = {
        # TODO wlan-eth bridge
        hostName = cfg.hostname;
        useDHCP  = false;

        interfaces = {
          "${cfg.uplink.interface}" = {
            useDHCP = true;
          };
          "${cfg.local.interface}" = {
            useDHCP = false;
            ipv4.addresses =
              [ {
                address      = "${cfg.local.net}.${cfg.local.ip}"; # TODO remove copy/paste
                prefixLength = 24;
              } ];
          };
        };

        nat = {
          enable            = true;
          # enableIPv6 = true;
          externalInterface  = cfg.uplink.interface;
          internalInterfaces = [ cfg.local.interface ];
        };
      };

      # TODO

      # services.hostapd = {
      #   enable        = true;
      #   wpaPassphrase = "testpassword";
      #   interface     = "wlp2s0b1";
      #   ssid          = "Petrovi4New";
      #   channel       = 1;
      #   # countryCode   = "RU";
      #   extraConfig   =
      #     ''
      #       ieee80211n=1
      #       wpa_key_mgmt=WPA-PSK
      #       rsn_pairwise=CCMP
      #     '';
      # };

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
