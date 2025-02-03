#
# TODO:
#  - reload bind when zone is changed
#  - dnssec
#
{ pkgs, lib, self, deps, config, ... }:
with lib;
let
  dns     = deps.inputs.dns;
  address = config.tfattrs.hcloud_server.srv1.ipv4_address;
  domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
in {
  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
  # NOTE если падает деплой bind это ломает последующие деплои
  networking.resolvconf.useLocalResolver = mkForce false;
  services.bind = let
    baseZone = {
      SOA = {
        nameServer = "ns1.${domain}.";
        adminEmail = "admin@${domain}";
        serial     = self.lastModified; # is it ok?
        ttl        = 60 * 60; # 1h
      };
      NS = [
        "ns1.${domain}."
        "ns2.${domain}."
      ];
    };
    file = dns.util.${pkgs.system}.writeZone domain (recursiveUpdate baseZone (with dns.lib.combinators; {
      A = [ address ];
      subdomains = {
        vpn  = host address null;
        sync = host address null;
        ns1  = host address null;
        ns2  = host address null;
      };
    }));
  in {
    enable = true;
    forwarders = [ "1.1.1.1" ];
    ipv4Only = true;
    zones.${domain} = {
      file = file;
      master = true;
      slaves = [];
    };
    extraOptions = ''
      max-cache-size 5%;
      '';
    extraConfig = ''
      logging {
        channel default_syslog {
          syslog daemon;
          severity warning;
        };
      };
      '';
  };
}
