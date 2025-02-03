{ config, ... }: {
  mynixos.dns = {
    enable  = true;
    address = config.tfattrs.hcloud_server.srv1.ipv4_address;
    domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
  };
}
