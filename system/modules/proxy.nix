# proxing internal traffic outside
{ config, lib, ... }:
with lib;
let
  cfg = config.mynixos.proxy;
  allowPortsOnInterfaces = ports:
    listToAttrs (map (name: { inherit name; value = { allowedTCPPorts = ports; }; }) cfg.interfaces);
in {
  options.mynixos.proxy = with types; {
    enable = mkEnableOption "";
    interfaces = mkOption {
      type    = listOf str;
      default = [ "wg0" ];
    };
    address = mkOption {
      type = str;
    };
    port = mkOption {
      type    = int;
      default = 8118;
    };
    endpoint = mkOption {
      type     = str;
      default  = "${cfg.address}:${toString cfg.port}";
      readOnly = true;
    };
    tor = {
      enable = mkEnableOption "";
      port = mkOption {
        type    = int;
        default = 9050;
      };
      endpoint = mkOption {
        type     = str;
        default  = "${cfg.address}:${toString cfg.tor.port}";
        readOnly = true;
      };
    };
    i2p = {
      enable = mkEnableOption "";
      port = mkOption {
        type    = int;
        default = 4447;
      };
      endpoint = mkOption {
        type     = str;
        default  = "${cfg.address}:${toString cfg.i2p.port}";
        readOnly = true;
      };
    };
  };

  config =
    mkIf cfg.enable (mkMerge [
      {
        services.privoxy = {
          enable = true;
          settings.listen-address = cfg.endpoint;
        };
        networking.firewall.interfaces = allowPortsOnInterfaces [ cfg.port ];
      }
      (mkIf cfg.tor.enable {
        services.tor = {
          enable = true;
          client.enable = true;
          settings.SOCKSPort = [ { addr = cfg.address; port = cfg.tor.port; } ];
        };
        services.privoxy.settings."forward-socks5 .onion" = "${cfg.tor.endpoint} .";
        networking.firewall.interfaces = allowPortsOnInterfaces [ cfg.tor.port ];
      })
      (mkIf cfg.i2p.enable {
        services.i2pd = {
          enable = true;
          proto.socksProxy = {
            enable  = true;
            address = cfg.address;
            port    = cfg.i2p.port;
          };
        };
        services.privoxy.settings."forward-socks5 .i2p" = "${cfg.i2p.endpoint} .";
        networking.firewall.interfaces = allowPortsOnInterfaces [ cfg.i2p.port ];
      })
    ]);
}
