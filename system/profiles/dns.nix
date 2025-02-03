{ config, ... }: {
  mynixos.dns = {
    enable  = true;
    ext = {
      address = config.tfattrs.hcloud_server.srv1.ipv4_address;
      domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
    };
    int = {
      address   = "${config.mynixos.secrets.vpnSubnet}.${config.mynixos.secrets.vpn.srv1.addr}"; # TODO find better way
      domain    = "internal";
      upstreams = [ "1.1.1.1" "8.8.8.8" ];
      subnets   = [ "${config.mynixos.secrets.vpnSubnet}.0/24" ];
    };
  };
}
