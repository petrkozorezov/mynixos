#
# TODO:
#  - reload bind when zone is changed
#  - dnssec
#
{ lib, self, deps, system, config, ... }:
with lib;
let
  dns     = deps.inputs.dns;
  address = config.tfattrs.hcloud_server.helsinki1.ipv4_address;
  domain  = config.tfattrs.hcloud_rdns.master.dns_ptr;
  ddnsZoneName = "knk.${domain}";
in {
  networking.firewall = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
  networking.resolvconf.useLocalResolver = mkForce false;
  services.bind = let
    baseZone =
      with dns.lib.combinators; {
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
  in {
    enable = true;
    zones = let
      zone = recursiveUpdate baseZone (with dns.lib.combinators; {
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

    ddns = {
      zone    = ddnsZoneName;
      keyfile = config.sss.secrets."ddns-${ddnsZoneName}".target;
      server = {
        enable       = true;
        seedZoneFile = dns.util.${system}.writeZone ddnsZoneName (recursiveUpdate baseZone { SOA.ttl = 60; });
      };
    };
  };
  sss.secrets."ddns-${ddnsZoneName}" = {
    target    = "/run/named/ddns-${ddnsZoneName}";
    text      = config.zoo.secrets.dnssec.tsig.${ddnsZoneName};
    user      = "named";
    dependent = [ "bind.service" ];
  };
  users.users.named.extraGroups = [ "keys" ];
}
