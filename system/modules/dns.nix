# super simple dns server configuration for one server with one domain with subdomains
#
# [dnssec checker](https://dnssec-analyzer.verisignlabs.com/)
# [knot tutorial](https://aryak.me/blog/01-knot)
# `knotc zone-read myzone.com | grep -v RRSIG` to inspect
{ pkgs, lib, self, deps, config, ... }:
with lib;
let
  cfg     = config.mynixos.dns;
  dns     = deps.inputs.dns;
  dataDir = "/var/lib/knot/";
in {
  options.mynixos.dns = with lib.types; {
    enable = mkEnableOption "whether to enable mynixos dns service";

    address = mkOption {
      type = str;
    };

    domain = mkOption {
      type = str;
    };

    subdomains = mkOption {
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    assertions = [ {
      assertion = config.mynixos.backups.enable;
      message   = "backups uses backups system, please enable and setup it";
    } ];

    networking.firewall = {
      allowedUDPPorts = [ 53 ];
      allowedTCPPorts = [ 53 ];
    };
    networking.resolvconf.useLocalResolver = mkForce false;

    services.knot = let
      baseZone = {
        SOA = {
          nameServer = "ns1.${cfg.domain}.";
          adminEmail = "admin@${cfg.domain}";
          serial     = self.lastModified; # is it ok?
          ttl        = 60 * 60; # 1h
        };
        NS = [
          "ns1.${cfg.domain}."
          "ns2.${cfg.domain}."
        ];
      };
      zoneFile = dns.util.${pkgs.system}.writeZone cfg.domain (recursiveUpdate baseZone (with dns.lib.combinators; {
        A = [ cfg.address ];
        subdomains = listToAttrs (map
          (name: {
            inherit name;
            value = host cfg.address null;
          })
          ([ "ns1" "ns2" ] ++ cfg.subdomains)
        );
      }));
    in {
      enable = true;
      settings = {
        server = {
          rundir = "/run/knot";
          user = "knot:knot";
          listen = "0.0.0.0@53"; # TODO only external
        };
        log.syslog.any = "info";
        database.storage = dataDir;

        # `keymgr your.domain ds`
        zone.${cfg.domain} = {
          file = zoneFile;
          dnssec-signing = "on";
          semantic-checks = "on";
          storage = "${dataDir}/zones";
          # Don't override zonefile
          zonefile-sync = -1;
        };
      };
    };

    mynixos.backups.snapshots.knot.paths = [ dataDir ];
  };
}
