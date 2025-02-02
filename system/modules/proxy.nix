# proxing internal traffic outside
{ config, lib, ... }:
with lib;
let
  cfg = config.mynixos.proxy;
  address = "${cfg.network}.${cfg.address}";
in {
  options.mynixos.proxy = {
    enable = mkEnableOption "";
    interface = mkOption {
      type    = types.str;
      default = "wg0";
    };
    address = mkOption {
      type    = types.str;
      default = "1";
    };
    network = mkOption {
      type = types.str;
    };
    mask = mkOption {
      type = types.str;
      default = "/24";
    };
    port = mkOption {
      type    = types.int;
      default = 8118;
    };
    endpoint = mkOption {
      type     = types.str;
      default  = "${address}:${toString cfg.port}";
      readOnly = true;
    };
    tor = {
      enable = mkEnableOption "";
      port = mkOption {
        type    = types.int;
        default = 9050;
      };
      endpoint = mkOption {
        type     = types.str;
        default  = "${address}:${toString cfg.tor.port}";
        readOnly = true;
      };
    };
    i2p = {
      enable = mkEnableOption "";
      port = mkOption {
        type    = types.int;
        default = 4447;
      };
      endpoint = mkOption {
        type     = types.str;
        default  = "${address}:${toString cfg.i2p.port}";
        readOnly = true;
      };
    };
  };

  config =
    mkIf cfg.enable (mkMerge [
      {
        services.privoxy = {
          enable = true;
          settings = {
            listen-address = cfg.endpoint;
            permit-access  = "${cfg.network}.0${cfg.mask}";
          };
        };
        networking.firewall = {
          interfaces.${cfg.interface}.allowedTCPPorts = [ cfg.port ];
          allowPing = false; # TODO disable ping only from external interface
        };
      }
      (mkIf cfg.tor.enable {
        services.tor = {
          enable = true;
          client.enable = true;
          settings.SOCKSPort = [ { addr = address; port = cfg.tor.port; } ];
        };
        services.privoxy.settings."forward-socks5 .onion" = "${cfg.tor.endpoint} .";
        networking.firewall.interfaces.${cfg.interface}.allowedTCPPorts = [ cfg.tor.port ];
      })
      (mkIf cfg.i2p.enable {
        services.i2pd = {
          enable = true;
          proto.socksProxy = {
            enable = true;
            inherit address;
            port = cfg.i2p.port;
          };
        };
        services.privoxy.settings."forward-socks5 .i2p" = "${cfg.i2p.endpoint} .";
        networking.firewall.interfaces.${cfg.interface}.allowedTCPPorts = [ cfg.i2p.port ];
      })
    ]);
}
