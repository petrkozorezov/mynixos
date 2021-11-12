#
# TODO:
#  - dnssec
#
{ lib, dns, flake, system, config, ... }:
with lib; {
  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
  networking.resolvconf.useLocalResolver = mkForce false;
  services.bind = let
    address = config.tfattrs.hcloud_server.helsinki1.ipv4_address;
    domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
    baseZone =
      with dns.lib.combinators; {
        SOA = {
          nameServer = "ns1.${domain}.";
          adminEmail = "admin@${domain}";
          serial     = flake.lastModified; # is it ok?
          ttl        = 60;
        };
        NS = [
          "ns1.${domain}."
          "ns2.${domain}."
        ];
      };
  in {
    enable = true;
    zones = let
      zone = baseZone // (with dns.lib.combinators; {
        A = [ address ];
        subdomains = {
          vpn = host address null;
          ns1 = host address null;
          ns2 = host address null;
        };
      });
    in {
      "${domain}" = {
        file   = dns.util.${system}.writeZone domain zone;
        master = true;
        slaves = [];
      };
    };

    ddns = rec {
      zone    = "knk.${domain}";
      keyfile = config.zoo.secrets.keys.dnssec.tsig."${zone}";
      server = {
        enable       = true;
        seedZoneFile = dns.util.${system}.writeZone zone baseZone;
      };
    };
  };
}
