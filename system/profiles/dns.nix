# [dnssec checker](https://dnssec-analyzer.verisignlabs.com/)
# [knot tutorial](https://aryak.me/blog/01-knot)
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
  networking.resolvconf.useLocalResolver = mkForce false;

  services.knot = let
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
    zoneFile = dns.util.${pkgs.system}.writeZone domain (recursiveUpdate baseZone (with dns.lib.combinators; {
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
    settings = {
      server = {
        rundir = "/run/knot";
        user = "knot:knot";
        listen = "0.0.0.0@53";
      };
      log.syslog.any = "info";
      database.storage = "/var/lib/knot";

      # `keymgr your.domain ds`
      zone.${domain} = {
        file = zoneFile;
        dnssec-signing = "on";
        semantic-checks = "on";
        storage = "/var/lib/knot/zones";
        # Don't override zonefile
        zonefile-sync = -1;
      };
    };
  };
}
