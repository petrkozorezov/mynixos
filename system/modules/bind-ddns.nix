{ config, lib, pkgs, system, ... }:
with lib; {
  options.services.bind.ddns = {
    zone = mkOption {
      type        = types.str;
      example     = "foo.com";
      description = "Name of dynamic zone.";
    };
    keyfile = mkOption {
      type        = types.path;
      description = "Path to TSIG key file (result of `tsig-keygen` command).";
    };
    keyname = mkOption {
      type        = types.str;
      default     = config.services.bind.ddns.zone;
      description = "Name of tsig key (`tsig-keygen` command argument).";
    };

    server = {
      enable   = mkEnableOption "DDNS server";
      seedZoneFile = mkOption {
        type = types.path;
        description = "A \"seed\" zone file for the subdomain we want to be able to dynamically update.";
      };
    };

    client = {
      enable = mkEnableOption "DDNS client";
      updates = mkOption {
        type = types.listOf types.str;
        description = "List of update commands (without 'update' prefix).";
        example = [
          "delete test.foo.com A"
          "add test.foo.com A 42.42.42.42"
        ];
      };
      server = mkOption {
        type        = types.str;
        description = "Hostname of dns server with dynamic zone.";
      };
    };
  };

  config = let
    cfg = config.services.bind.ddns;
    etcSeedZoneFile = "bind/zones/${cfg.zone}";
    keyfile = toString cfg.keyfile;
    clientConfig =
      mkIf cfg.client.enable {
        systemd.timers.ddns-client-update = {
          description = "DDNS client updater timer";
          timerConfig = {
            OnBootSec       = "0m";
            OnUnitActiveSec = "1m";
          };
          wantedBy = [ "timers.target" ];
        };
        systemd.services.ddns-client-update = {
          description = "DDNS client updater service";
          script =
            ''
              echo "
              server ${cfg.client.server}
              zone ${cfg.zone}
              ${lib.concatMapStrings (update: "update ${update}\n") cfg.client.updates}
              send" | ${pkgs.bind.dnsutils}/bin/nsupdate -k ${keyfile}
            '';
          serviceConfig = {
            Type       = mkForce "simple";
            Restart    = mkForce "always";
            RestartSec = mkForce "5";
          };
          unitConfig.StartLimitInterval = "0";
        };
      };
    serverConfig =
      mkIf cfg.server.enable {
        services.bind = {
          enable = true;
          extraConfig = "include \"${keyfile}\";";
          zones = {
            "${cfg.zone}" = {
              file        = "/etc/${etcSeedZoneFile}";
              master      = true;
              extraConfig = "allow-update { key \"${cfg.keyname}\"; };";
            };
          };
        };
        environment.etc."${etcSeedZoneFile}".source = cfg.server.seedZoneFile;
        systemd.tmpfiles.rules = [ "d /etc/bind/zones 0755 named root -" ];
        # to avoid "journal out of sync" after seed zone file updates
        systemd.services.bind.preStart = "rm -f /etc/bind/zones/*.jnl";
      };
  in mkMerge [ clientConfig serverConfig ];
}
