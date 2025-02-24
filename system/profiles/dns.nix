{ config, ... }: {
  mynixos.dns = {
    enable = true;
    # addresses are need to be set in main server profile
    ext.domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
    int = {
      domain    = "internal";
      upstreams = [ "1.1.1.1" "8.8.8.8" ];
      subnets   = [ config.tfattrs.hcloud_network.network.ip_range ];
    };
  };
}
