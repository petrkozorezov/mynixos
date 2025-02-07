{ config, ... }: {
  mynixos.webserver = {
    enable = true;
    int.domain = config.mynixos.dns.int.domain;
    ext.domain = config.mynixos.dns.ext.domain;
  };
}
