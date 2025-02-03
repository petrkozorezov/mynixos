# super simple dns server configuration for one server with one domain with subdomains
#
# [dnssec checker](https://dnssec-analyzer.verisignlabs.com/)
# [knot tutorial](https://aryak.me/blog/01-knot)
# `knotc zone-read myzone.com | grep -v RRSIG` to inspect
{ pkgs, lib, self, deps, config, ... }:
with lib;
let
  cfg = config.mynixos.dns;
  dns = deps.inputs.dns;
  knotDataDir = "/var/lib/knot/";
in {
  options.mynixos.dns = with lib.types; {
    enable = mkEnableOption "whether to enable mynixos dns service";

    ext = mkOption { type = submodule { options = {
      address = mkOption {
        type = str;
      };

      domain = mkOption {
        type = str;
      };

      subdomains = mkOption {
        type = listOf str;
        default = [];
      };
    };};};

    int = mkOption { type = submodule { options = {
      address = mkOption {
        type = str;
      };

      domain = mkOption {
        type = str;
      };

      subdomains = mkOption {
        type = listOf str;
        default = [];
      };

      upstreams = mkOption { type = listOf str; };
      subnets = mkOption { type = listOf str; };
    };};};


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
    # NOTE проблема в том, что если падает локальный резолвер (bind) то ломаются деплои, но резолвить локальные хосты нужно
    # починить это можно заменой 127.0.0.1 на 1.1.1.1 в /etc/resolf.conf
    networking.resolvconf.useLocalResolver = true;

    # external zone
    services.knot = let
      baseZone = {
        SOA = {
          nameServer = "ns1.${cfg.ext.domain}.";
          adminEmail = "admin@${cfg.ext.domain}";
          serial     = self.lastModified; # is it ok?
          ttl        = 60 * 60; # 1h
        };
        NS = [
          "ns1.${cfg.ext.domain}."
          "ns2.${cfg.ext.domain}."
        ];
      };
      zoneFile = dns.util.${pkgs.system}.writeZone cfg.ext.domain (recursiveUpdate baseZone (with dns.lib.combinators; {
        A = [ cfg.ext.address ];
        subdomains = listToAttrs (map
          (name: {
            inherit name;
            value = host cfg.ext.address null;
          })
          ([ "ns1" "ns2" ] ++ cfg.ext.subdomains)
        );
      }));
    in {
      enable = true;
      settings = {
        server = {
          rundir = "/run/knot";
          user = "knot:knot";
          listen = "${cfg.ext.address}@53";
        };
        log.syslog.any = "info";
        database.storage = knotDataDir;

        # `keymgr your.domain ds`
        zone.${cfg.ext.domain} = {
          file = zoneFile;
          dnssec-signing = "on";
          semantic-checks = "on";
          storage = "${knotDataDir}/zones";
          # Don't override zonefile
          zonefile-sync = -1;
        };
      };
    };

    mynixos.backups.snapshots.knot.paths = [ knotDataDir ];

    # internal zone + caching
    services.bind = let
      baseZone = {
        SOA = {
          nameServer = "ns1.${cfg.int.domain}.";
          adminEmail = "admin@${cfg.int.domain}";
          serial     = self.lastModified; # is it ok?
          ttl        = 60 * 60; # 1h
        };
        NS = [
          "ns1.${cfg.int.domain}."
        ];
      };
      file = dns.util.${pkgs.system}.writeZone cfg.int.domain (recursiveUpdate baseZone (with dns.lib.combinators; {
        A = [ cfg.int.address ];
        subdomains = listToAttrs (map
          (name: {
            inherit name;
            value = host cfg.int.address null;
          })
          ([ "ns1" ] ++ cfg.int.subdomains)
        );
      }));
    in {
      enable = true;
      ipv4Only = true;
      listenOn = [ cfg.int.address "127.0.0.1" ];
      forwarders = cfg.int.upstreams;
      zones.${cfg.int.domain} = {
        file = file;
        master = true;
        slaves = [];
      };
      cacheNetworks = cfg.int.subnets ++ [ "127.0.0.0/8" ];
      extraOptions = ''
        max-cache-size 3%;
        dnssec-validation auto;
        auth-nxdomain no; # conform to RFC1035
        '';
        # recursion yes;
      extraConfig = ''
        logging {
          channel default_syslog {
            syslog daemon;
            severity warning;
          };
        };
        '';
    };
  };
}
