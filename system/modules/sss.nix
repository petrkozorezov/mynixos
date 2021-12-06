{ pkgs, config, lib, ... }:
with lib;
let
  cfg  = config.sss;
  esc  = strings.escapeShellArg;
  escp = arg: esc (toString arg);
in {
  options = {
    sss = {
      enable = mkEnableOption "";

      path = mkOption {
        description = "";
        type        = types.path;
        default     = /run/keys;
      };

      commands = {
        encrypt = mkOption {
          description = "Command reads plain secret from stdin encrypt and writes result to stdout.";
          type        = types.str;
          example     = "${pkgs.rage}/bin/rage -e -r 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwzqyKI0/H6h8yiZLCyUE914PZXXLHA9BhdOSwLUEEN'";
        };
        decrypt = mkOption {
          description = "Command reads encrypted secret from stdin decrypt and writes result to stdout.";
          type        = types.str;
          example     = "${pkgs.rage}/bin/rage -d -i /etc/ssh/ssh_host_ed25519_key";
        };
      };

      secrets = mkOption {
        description = "";
        type = types.attrsOf (types.submodule ({ name, config, ... }: let
          secretName = name;
          secretCfg  = config;
        in {
          options = {
            enable = mkOption {
              default     = true;
              description = "The way to quickly disable decryption of the secret.";
              type        = types.bool;
            };

            service = mkOption {
              description = ''
                Name of systemd service, you have to make your service(s) dependent on
                to guarantee service(s) has secret decrypted on start.
              '';
              type    = types.str;
              default = "sss-secret-${secretName}";
            };

            dependent = mkOption {
              description = "";
              type        = types.listOf types.str;
              default     = [ "multi-user.target" ];
            };

            text = mkOption {
              description = "";
              type        = types.nullOr types.str;
              example     = "your very sensitive secret";
            };

            source = mkOption {
              description = "";
              type        = types.path;
              default     = pkgs.writeText "sss-${secretName}-plain" secretCfg.text;
            };

            encrypted = mkOption {
              description = "";
              type        = types.path;
              default     = pkgs.runCommandLocal "sss-${secretName}-encrypted" {} "cat ${escp secretCfg.source} | ${secretCfg.encryptCommand} > $out";
            };

            encryptCommand = mkOption {
              description = "";
              type        = types.str;
              default     = cfg.commands.encrypt;
            };

            decryptCommand = mkOption {
              description = "";
              type        = types.str;
              default     = cfg.commands.decrypt;
            };

            target = mkOption {
              description = "Full path of unencrypted secret.";
              type        = types.path;
              default     = cfg.path + "/${name}";
            };

            tmp = mkOption {
              description = "";
              type        = types.path;
              default     = secretCfg.target + ".tmp";
            };

            mode = mkOption {
              description = "";
              type        = types.str;
              default     = "400";
            };

            user = mkOption {
              description = "";
              type        = types.str;
              default     = "root";
            };

            group = mkOption {
              description = "";
              type        = types.str;
              default     = "root";
            };
          };
        }));
        default = {};
        example = {
          foo = {
            source = ./secrets/my_secret;
            dependent = [ "my-service.service" ];
          };
        };
      };
    };
  };

  config = let
    service =
      name: secret:
        nameValuePair "${secret.service}" (
          let
            source  = escp secret.encrypted;
            target  = escp secret.target;
            tmp     = escp secret.tmp;
          in mkIf secret.enable {
            preStart = ''
              test -f ${source} || (echo "unencrypted secret is not exist" && exit 1)
              mkdir -p $(dirname ${target})
              mkdir -p $(dirname ${tmp})
            '';

            # TODO test error case
            script = ''
              if (
                echo -n "Decrypting..."
                cat ${source} | ${secret.decryptCommand} > ${tmp}
                chown ${esc secret.user}:${esc secret.group} ${tmp}
                chmod ${esc secret.mode} ${tmp}
                mv -f ${tmp} ${target}
              ); then
                echo "Ok"
              else
                echo "Failed"
                rm -f ${tmp}
                exit 1
              fi
            '';

            preStop = ''
              rm -f ${target}
            '';

            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = "yes";
            };

            requiredBy = secret.dependent;
            before     = secret.dependent;
          }
      );
  in mkIf cfg.enable {
    systemd.services = mapAttrs' service cfg.secrets;
  };
}
