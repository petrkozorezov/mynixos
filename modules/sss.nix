{ pkgs, config, lib, ... }:
with lib;
let
  cfg  = config.sss;
  esc  = strings.escapeShellArg;
  escp = arg: esc (toString arg);
in {
  options = {
    sss = let
      secrets = mkOption {
        description = "List of secrets.";
        type = types.attrsOf (types.submodule ({ name, config, ... }: let
          secretName = name;
          secretCfg  = config;
        in {
          options = {
            name = mkOption {
              default     = name;
              description = "Name of the secret.";
              type        = types.str;
            };

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
              description = "Systemd services that dependent of this secret ('requiredBy' and 'before' unit file section).";
              type        = types.listOf types.str;
              default     = [ "multi-user.target" ];
            };

            text = mkOption {
              description = "Text of the secret, will be overridden by 'source' or 'encrypted'.";
              type        = types.nullOr types.str;
              example     = "your very sensitive secret";
            };

            source = mkOption {
              description = "File with the plain secret text, will override 'text' and will be overridden by 'encrypted'.";
              type        = types.path;
              default     = pkgs.writeText "sss-${secretName}-plain" secretCfg.text;
            };

            encrypted = mkOption {
              description = "Encrypted version of the secret file, will override 'text' and 'source'.";
              type        = types.path;
              default     = pkgs.runCommandLocal "sss-${secretName}-encrypted" {} "cat ${escp secretCfg.source} | ${secretCfg.encryptCommand} > $out";
            };

            encryptCommand = mkOption {
              description = "Command reads plain secret from stdin encrypt and writes result to stdout.";
              type        = types.str;
              default     = cfg.commands.encrypt;
            };

            decryptCommand = mkOption {
              description = "Command reads encrypted secret from stdin decrypt and writes result to stdout.";
              type        = types.str;
              default     = cfg.commands.decrypt;
            };

            target = mkOption {
              description = "Full path of unencrypted secret.";
              type        = types.path;
              default     = cfg.path + "/${config.name}";
            };

            tmp = mkOption {
              description = "Temporary location of the secret file during decription.";
              type        = types.path;
              default     = secretCfg.target + ".tmp";
            };

            mode = mkOption {
              description = "Access mode of the secret file.";
              type        = types.str;
              default     = "400";
            };

            user = mkOption {
              description = "Owner user of the secret file.";
              type        = types.str;
              default     = "$USER";
            };

            group = mkOption {
              description = "Owner group of the secret file.";
              type        = types.str;
              default     = "nogroup";
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
    in {
      enable = mkEnableOption "";

      path = mkOption {
        description = "Path where unencrypted keys will be located by default.";
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

      inherit secrets;
      user = { inherit secrets; };
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
              test -f ${source} || (echo "encrypted secret is not exist" && exit 1)
              mkdir -p $(dirname ${target})
              mkdir -p $(dirname ${tmp   })
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
              Type            = "oneshot";
              RemainAfterExit = "yes";
            };

            requiredBy = secret.dependent;
            before     = secret.dependent;
          }
      );
  in mkIf cfg.enable {
    systemd.services      = mapAttrs' service cfg.secrets     ;
    systemd.user.services = mapAttrs' service cfg.user.secrets;
  };
}
