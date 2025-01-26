{ config, ... }: {
  mynixos.vpn = {
    enable = true;
    subnet = config.mynixos.secrets.vpnSubnet;
    vpnIf  = "wg0";
    peers  = config.mynixos.secrets.vpn;
  };
}
