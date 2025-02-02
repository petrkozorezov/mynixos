#
# почему отдельный модуль
# - если сделать самым простым путём и просто добавлять пути в один бэкап, то exclud'ы могут конфликтовать
# - если сделать разные бэкапы в один репозиторий, то нужно будет каждый раз прописывать зависимость сервиса от сектетов
#
# TODO:
#  - [mail notifications](https://serverfault.com/questions/694818/get-notification-when-systemd-monitored-service-enters-failed-state)
#  - Prune и check бы сделать отдельно, но можно и так пожить наверное
#  - сделать возможность в разные репозитории сохранять разные снепшоты (а не всё в один)
#  - run from special user
{ lib, config, ... }: with lib; let
  cfg = config.mynixos.backups;
  secretsCfg = config.sss.secrets;
in {
  options.mynixos.backups = with lib.types; {
    enable = mkEnableOption "whether to enable mynixos automatic backups";

    password = mkOption {
      type = str;
      description = "Backup password. Will be save as sss secret.";
    };

    s3repo = mkOption { type = submodule { options = {
      keyID = mkOption { type = str; };
      appKey = mkOption { type = str; };
      endpoint = mkOption { type = str; };
    }; }; };

    exclude = mkOption {
      type = listOf str;
      default = [ ];
    };

    snapshots = mkOption { type =
      attrsOf (submodule ({ name, ... }: {
        options = {
          name = mkOption {
            default     = name;
            description = "Name of the secret.";
            type        = types.str;
          };

          enable = mkOption {
            default = true;
            type = types.bool;
          };

          paths = mkOption {
            type = listOf str;
            default = [ ];
          };

          exclude = mkOption {
            type = listOf str;
            default = [ ];
          };
        };
      }));
    };
  };

  config = let
    resticBackup = name: snapCfg: let
      tag = "name:${snapCfg.name}";
      commonOpts = [
        "--tag ${tag}"
        # "--host ${config.networking.hostName}"
        # "что"
        # тэги уникально идентифицируют содержимое
        # позволяет менять путь к директориям и имена хостов
        # !!!при бэкапе нужно всега указывать тэг!!!
        "--group-by tags"
      ];
    in nameValuePair snapCfg.name (mkIf snapCfg.enable {
      inherit (snapCfg) paths exclude;
      initialize = true;
      passwordFile = toString secretsCfg.restic-password.target;
      environmentFile = toString secretsCfg.restic-env.target;
      repository = cfg.s3repo.endpoint;

      timerConfig = {
        OnCalendar = "04:00";
        RandomizedDelaySec = "3h";
      };

      extraBackupArgs = commonOpts ++ [
        "--no-scan"
      ];

      pruneOpts = commonOpts ++ [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
        "--keep-yearly 10"
      ];
      checkOpts = [
        "--with-cache"
        "--read-data-subset=1%"
      ];
    });
    snapSecretsDeps = snapCfg: let
      resticService =
        assert lib.asserts.assertMsg
          (builtins.hasAttr "restic-backups-${snapCfg.name}" config.systemd.services)
          "restic-backups-${snapCfg.name}.service is not found";
        "restic-backups-${snapCfg.name}.service";
    in mkIf snapCfg.enable {
      # multi-user.target for wrapper script
      restic-env.dependent = [ resticService "multi-user.target" ];
      restic-password.dependent = [ resticService "multi-user.target" ];
    };
    resticBackups = mapAttrs' resticBackup cfg.snapshots;
    sssSecrets = map snapSecretsDeps (attrValues cfg.snapshots);
  in mkIf cfg.enable {
    services.restic.backups = resticBackups;
    sss.secrets = mkMerge (sssSecrets ++ [{
      restic-env.text = ''
        AWS_ACCESS_KEY_ID=${cfg.s3repo.keyID}
        AWS_SECRET_ACCESS_KEY=${cfg.s3repo.appKey}
        '';
      restic-password.text = cfg.password;
    }]);
  };
}
