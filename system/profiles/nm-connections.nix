{ config, lib, pkgs, ... }: with lib; {
  networking.networkmanager.connections =
    let
      inherit (config.mynixos) secrets;
      wifis =
        flip mapAttrs' secrets.wifi (
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
        self = secrets.vpn.${config.networking.hostName};
      in {
        srv1 = {
          connection = rec {
            id   = "srv1";
            uuid = "607b0ac2-6b3c-4a36-9618-c5a8aec262d2";
            type = "wireguard";
            interface-name = id;
            autoconnect    = true;
          };
          wireguard.private-key = self.priv;
          "wireguard-peer.${secrets.vpn.srv1.pub}" = {
            endpoint             = "${secrets.vpn.srv1.endpoint}:${builtins.toString secrets.vpn.srv1.port}";
            persistent-keepalive = "25";
            allowed-ips          = "${secrets.vpnSubnet}.0/24";
          };
          # TODO remove hardcode
          ipv4 = {
            method   = "manual";
            address1 = "${secrets.vpnSubnet}.${self.addr}/32";
            dns      = "${secrets.vpnSubnet}.${secrets.vpn.srv1.addr}";
          };
          ipv6.method = "disabled";
          proxy = {
            method     = "1 ";
            pac-script = "function FindProxyForURL(url, host) { PROXY ${secrets.vpnSubnet}.${secrets.vpn.srv1.addr}:8118; }";
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
