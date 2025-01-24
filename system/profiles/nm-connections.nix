{ config, lib, pkgs, ... }:
with lib; {
  networking.networkmanager.connections =
    let
      wifis =
        flip mapAttrs' config.mynixos.secrets.wifi (
          uuid: connection:
            nameValuePair
              uuid
              {
                connection = {
                  id   = connection.ssid;
                  uuid = uuid;
                  type = "wifi";
                };
                wifi = {
                  ssid = connection.ssid;
                  mode = "infrastructure";
                };
                wifi-security = {
                  auth-alg = "open";
                  key-mgmt = "wpa-psk";
                  psk      = connection.passphrase;
                };
                ipv4 = { method = "auto"; };
                ipv6 = { method = "auto"; };
              }
          );
      vpn = let
        cfg       = config.mynixos.secrets.vpn;
        self      = cfg.${config.networking.hostName};
        helsinki1 = cfg.helsinki1;
        router    = cfg.router;
        net       = "192.168.4";
      in {
        helsinki1 =
          {
            connection = rec {
              id   = "helsinki1";
              uuid = "1d98ff68-0a2c-4834-8d8b-7bb9888080aa";
              type = "wireguard";
              interface-name = id;
              autoconnect    = true;
            };
            wireguard.private-key = self.priv;
            "wireguard-peer.${helsinki1.pub}" = {
              endpoint             = "${helsinki1.endpoint}:${builtins.toString helsinki1.port}";
              persistent-keepalive = "25";
              allowed-ips          = "0.0.0.0/0";
            };
            # TODO remove hardcode
            ipv4 = {
              method   = "manual";
              address1 = "${net}.${self.addr}/32";
              dns      = "1.1.1.1;"; # TODO use ${net}.${helsinki1.addr}
            };
            ipv6.method = "disabled";
            proxy = {
              method     = "1 ";
              pac-script = "function FindProxyForURL(url, host) { PROXY ${net}.${helsinki1.addr}:8118; }";
            };
          };
        };
      in vpn // wifis;

  # to allow send all traffic through wg
  networking.firewall.checkReversePath = false;
}

# TODO enable system wide proxy, see:
# - https://wiki.gnome.org/Projects/NetworkManager/Proxies
# - https://github.com/manugarg/pacparser
#
# to get pac from nmcli
# ''
#   IFS=$'\n'
#   for D in $(nmcli -g NAME c show --active); do
#     R=$(nmcli -g proxy.pac-script c show "$D");
#     if [ "$R" != "" ]; then
#       echo $R;
#       break;
#     fi;
#   done
# ''
