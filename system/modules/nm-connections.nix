{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.networking.networkmanager;
  ini = pkgs.formats.ini {};
in {
  options.networking.networkmanager.connections =
    mkOption {
      type    = types.attrsOf ini.type;
      default = {};
      description = ''
        Connections in format of the ini files placed in NetworkManager/system-connections.
      '';
      example =
        {
          linksys =
            {
              connection = {
                id   = "linksys";
                uuid = "8bb940e2-a899-413e-8bce-c33a15840a5a";
                type = "wifi";
              };
              wifi = {
                ssid     = "linksys";
                mode     = "infrastructure";
                security = "wifi-security";
              };
              wifi-security = {
                auth-alg = "open";
                key-mgmt = "wpa-psk";
                psk      = "testpassword";
              };
              ipv4 = { method = "auto"; };
              ipv6 = { method = "auto"; };
            };
        };
    };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.sss.enable; message = "SSS secrets system is not enabled, please enable and setup it"; }
    ];

    sss.secrets =
      lib.mapAttrs'
        (
          uuid: connection:
            let fileName = uuid + ".nmconnection";
            in lib.nameValuePair "nm-${fileName}" {
              source    = ini.generate fileName connection;
              target    = "/etc/NetworkManager/system-connections/${fileName}";
              dependent = [ "NetworkManager.service" ];
            }
        )
        cfg.connections;
  };
}
