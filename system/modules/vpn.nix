## https://nixos.wiki/wiki/WireGuard
{ pkgs, config, options, lib, slib, ... }:
with lib;
with types;
{
  options.mynixos.vpn = {
    enable = mkEnableOption "Will wireguard VPN be enabled.";
    subnet =
      mkOption {
        example     = "192.168.1";
        type        = str;
        description = "The first octets of the vpn network. Full addr will be 'subnet + peer.addr + mask'";
      };
    mask =
      mkOption {
        default     = "/24";
        type        = str;
        description = "Mask part of ip addresses.";
      };
    vpnIf =
      mkOption {
        default     = "wg0";
        type        = str;
        description = "VPN interface name.";
      };
    extIf =
      mkOption {
        default     = null;
        example     = "ens3";
        type        = nullOr str;
        description = "Uplink interface name. If set NAT will be enabled.";
      };
    peers = mkOption {
      description = "Peers specification.";
      default = {};
      example = {
        hostFoo = {
          pub      = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
          priv     = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
          addr     = "1";
          endpoint = "foo.example.com";
        };
      };
      type = attrsOf (submodule
        {
          options = {
            pub =
              mkOption {
                example     = "xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=";
                type        = str;
                description = "The base64 public key of the peer generated by <command>wg genkey</command>.";
              };
            priv =
              mkOption {
                example     = "yAnz5TF+lXXJte14tji3zlMNq+hd2rYUIgJBgB3fBmk=";
                type        = str;
                description = "Base64 private key generated by <command>wg genkey</command>.";
              };
            port =
              mkOption {
                default     = 51822;
                example     = 12345;
                type        = port;
                description = "UDP port to listen.";
              };
            addr =
              mkOption {
                example     = "1";
                type        = str;
                description = "The last octet(s) of the peer ip in the vpn network.";
              };
            endpoint =
              mkOption {
                default     = null;
                example     = "foo.example.com";
                type        = nullOr str;
                description = "Endpoint IP or hostname of the peer, followed by a colon, and then a port number of the peer.";
              };
            routes =
              mkOption {
                default     = [ ];
                example     = [ "192.168.2.0/24" ];
                type        = listOf str;
                description = "Additional routes to add";
              };
          };
        });
    };
  };

  config =
    let
      cfg          = config.mynixos.vpn;
      fullAddr     = subnet: addr: mask: "${subnet}.${addr}${mask}";
      hostName     = config.networking.hostName;
      self         = builtins.getAttr hostName cfg.peers;
      others       = builtins.attrValues (builtins.removeAttrs cfg.peers [ hostName ]);
      isNatEnabled = cfg.extIf != null;
    in mkMerge [
      (mkIf cfg.enable {
        assertions = [
          { assertion = config.sss.enable; message = "SSS secrets system is not enabled, please enable and setup it"; }
        ];

        sss = {
          secrets."vpn-privkey-${hostName}" = {
            text      = self.priv;
            dependent = [ "wireguard-${cfg.vpnIf}.service" ];
          };
        };

        networking = {
          wireguard.interfaces."${cfg.vpnIf}" = rec {
            privateKeyFile = toString config.sss.secrets."vpn-privkey-${hostName}".target;
            ips            = [ (fullAddr cfg.subnet self.addr cfg.mask) ];
            listenPort     = self.port;
            table          = "main";
            peers          =
              builtins.map
                (other:
                  {
                    publicKey  = other.pub;
                    allowedIPs = [ (fullAddr cfg.subnet other.addr "/32") ] ++ other.routes;
                    endpoint   = mkIf (other.endpoint != null) "${other.endpoint}:${builtins.toString other.port}";
                  }
                )
                others;
          };

          firewall = {
            allowedUDPPorts = [ self.port ];

            extraCommands = let
              spec = { to = { addresses = [ (fullAddr cfg.subnet self.addr cfg.mask) ]; }; };
              rule =
                target: spec: {
                  chain  = "nixos-fw";
                  inherit spec target;
                };
              fwCmd = name: cmd: "iptables -w ${slib.firewall.command name cmd}";
            in ''
              # vpn: disable traffic from non vpn hosts
              ${fwCmd "insert-rule" (rule "nixos-fw-refuse" spec) }
              ${fwCmd "insert-rule" (rule "nixos-fw-accept" (spec // { from = { interface = cfg.vpnIf; }; }))}
              ${fwCmd "insert-rule" (rule "nixos-fw-accept" (spec // { from = { interface = "lo"     ; }; }))}
            '';
          };

          forwarding = {
            enable = true;
            firewall = {
              allow = [
                { from = { interface = cfg.vpnIf; }; }
                { to   = { interface = cfg.vpnIf; }; match = { states = [ "ESTABLISHED" "RELATED" ]; }; }
              ];
            };
          };
        };

        # HACK see https://github.com/NixOS/nixpkgs/pull/140890/
        systemd.services = listToAttrs (map
          (other:
            let
              keyToUnitName = replaceStrings
                [ "/" "-"    " "     "+"     "="      ]
                [ "-" "\\x2d" "\\x20" "\\x2b" "\\x3d" ];
              unitName = keyToUnitName other.pub;
            in nameValuePair "wireguard-${cfg.vpnIf}-peer-${unitName}" {
              serviceConfig = {
                Type       = mkForce "simple";
                Restart    = mkForce "always";
                RestartSec = mkForce "5";
              };
              unitConfig.StartLimitInterval = "0";
            }
          )
          others
        );

        mynixos.dns.ext.subdomains = [ "vpn" ];
      })
      (mkIf isNatEnabled {
        networking = {
          wireguard.interfaces."${cfg.vpnIf}" =
            let
              rule = {
                table = "nat";
                chain = "POSTROUTING";
                spec = {
                  from = { addresses = [ (fullAddr cfg.subnet "0" cfg.mask) ]; };
                  to   = { interface = cfg.extIf; };
                };
                target = "MASQUERADE";
              };
              fwCmd = name: cmd: "${pkgs.iptables}/bin/iptables -w ${slib.firewall.command name cmd}";
            in {
              postSetup    = fwCmd "append-rule"  rule;
              postShutdown = fwCmd "delete-rules" rule;
            };
          nat = {
            enable             = true;
            externalInterface  =   cfg.extIf;
            internalInterfaces = [ cfg.vpnIf ];
          };
        };
      })
    ];
}
