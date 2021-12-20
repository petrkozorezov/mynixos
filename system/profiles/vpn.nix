{ config, ... }:
{
  zoo.vpn = {
    enable = true;
    subnet = "192.168.4";
    vpnIf  = "wg0";
    peers  = config.zoo.secrets.vpn;
  };
}
