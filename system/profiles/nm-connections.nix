{ config, lib, pkgs, ... }:
with lib; {
  # TODO remove hardcode
  networking.networkmanager.connections =
    let
      wifis =
        flip mapAttrs' config.zoo.secrets.wifi (
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
                  ssid     = connection.ssid;
                  mode     = "infrastructure";
                  security = "wifi-security";
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
    in {
        helsinki1 =
          let
            cfg      = config.zoo.secrets.vpn;
            hostName = config.networking.hostName;
          in {
            connection = rec {
              id   = "helsinki1";
              uuid = "1d98ff68-0a2c-4834-8d8b-7bb9888080aa";
              type = "wireguard";
              interface-name = id;
            };
            wireguard = {
              private-key = cfg.${hostName}.priv;
            };
            "wireguard-peer.${cfg.helsinki1.pub}" = {
              endpoint             = "65.21.49.156:51822";
              persistent-keepalive = "25";
              allowed-ips          = "0.0.0.0/0";
            };
            ipv4 = {
              method   = "manual";
              address1 = "192.168.4.${cfg.${hostName}.addr}/32";
              dns      = "1.1.1.1;";
            };
            ipv6 = { method = "disabled"; };
          };
      } // wifis;
}
