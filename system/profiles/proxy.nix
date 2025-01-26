{ config, ... }: {
  mynixos.proxy = {
    enable  = true;
    network = config.mynixos.secrets.vpnSubnet;
  };
}
