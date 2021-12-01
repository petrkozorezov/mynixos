{ config, ... }:
{
  zoo.vpn = {
    enable = true;
    subnet = "192.168.4";
    intIf  = "wg0";
    peers  = config.zoo.secrets.vpn;
  };
}
