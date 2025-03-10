{ pkgs, config, lib, ... }:
with lib;
let
  cfg  = config.sss;
  esc  = arg: "\"${strings.replaceStrings ["\""] ["\\\""] arg}\"";
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

            serviceEnable = mkOption {
              default     = true;
              description = ''
                The way to quickly disable decryption systemd service
                (secret can be used "by hands", e.g. by `sss.secret.foo.readCommand`).
                '';
              type = types.bool;
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
              description = "Systemd services that need this secret ('RequiredBy', 'PartOf' and 'before' in systemd service).";
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
              default     = pkgs.runCommandLocal "sss-${secretName}-encrypted" {
                  src =
                    if pathHasContext (toString secretCfg.source)
                      then secretCfg.source
                      else builtins.path { path = secretCfg.source; name = "sss-${secretName}-source"; };
                } "cat $src | ${secretCfg.encryptCommand} > $out";
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

            echoCommand = mkOption {
              description = "Command to echo decrypted password (e.g. can be useful from `programs.msmtp.accounts.default.passwordeval`)";
              type        = types.str;
              default     = "cat ${escp secretCfg.encrypted} | ${secretCfg.decryptCommand}";
            };

            path = mkOption {
              description = "Path where unencrypted keys will be located by default.";
              type        = types.str;
              default     = cfg.path;
            };

            target = mkOption {
              description = "Full path of unencrypted secret.";
              type        = types.path;
              default     = secretCfg.path + "/${secretCfg.name}";
            };

            tmp = mkOption {
              description = "Temporary location of the secret file during description.";
              type        = types.path; # TODO change to str
              default     = secretCfg.target + ".tmp";
            };

            mode = mkOption {
              description = "Access mode of the secret file.";
              type        = types.str;
              default     = cfg.mode;
            };

            user = mkOption {
              description = "Owner user of the secret file.";
              type        = types.str;
              default     = cfg.user;
            };

            group = mkOption {
              description = "Group of the secret file.";
              type        = types.str;
              default     = cfg.group;
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
        type        = types.str;
        default     = "/run/keys";
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

      mode = mkOption {
        description = "Default access mode of the secret file.";
        type        = types.str;
        default     = "400";
      };

      user = mkOption {
        description = "Default owner user of the secret file.";
        type        = types.str;
        default     = "$(id -u)"; # nixos module -> root; hm -> user id
      };

      group = mkOption {
        description = "Default group of the secret file.";
        type        = types.str;
        default     = "nogroup";
      };

      inherit secrets;
      hm = { inherit secrets; };
    };
  };

  config = let
    scripts =
      secret:
        let
          source = escp secret.encrypted;
          target = escp secret.target;
          tmp    = escp secret.tmp;
          user   = esc  secret.user;
          group  = esc  secret.group;
        in {
          # TODO customize directory mode
          # TODO set correct mode/user/group to the all created directories in the path (not only the last)
          preStart = ''
            test -f ${source} || (echo "encrypted secret does not exist" && exit 1) &&
            install -d -m 0700 -o ${user} -g ${group} $(dirname ${target}) &&
            install -d -m 0700 -o ${user} -g ${group} $(dirname ${tmp   })
          '';

          script = ''
            if (
              echo -n "Decrypting '${target}'..." &&
              ${secret.echoCommand} > ${tmp} &&
              chown ${user}:${group} ${tmp} &&
              chmod ${esc secret.mode} ${tmp} &&
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
        };

    systemService =
      _: secret: let
        serviceScripts = scripts secret;
      in
        nameValuePair secret.service (
          mkIf secret.serviceEnable {
            inherit (serviceScripts) preStart script preStop;

            serviceConfig = {
              Type            = "oneshot";
              RemainAfterExit = "yes";
            };

            requiredBy = secret.dependent;
            partOf     = secret.dependent;
            before     = secret.dependent;
          }
      );

    systemdEsc = replaceStrings [ "\\" "@" ] [ "-" "_" ];
    # from nixpkgs
    makeJobScript = name: text:
      let
        scriptName = systemdEsc name;
        out = pkgs.writeTextFile {
          # The derivation name is different from the script file name
          # to keep the script file name short to avoid cluttering logs.
          name        = "unit-script-${scriptName}";
          executable  = true;
          destination = "/bin/${scriptName}";
          text = ''
            #!${pkgs.runtimeShell} -e
            ${text}
          '';
          checkPhase = ''
            ${pkgs.stdenv.shell} -n "$out/bin/${scriptName}"
          '';
        };
      in "${out}/bin/${scriptName}";

    hmService =
      name: secret: let
        serviceName    = secret.service;
        serviceScripts = scripts secret;
      in
        nameValuePair serviceName (mkIf secret.serviceEnable {
          Unit = {
            Description = "Sss ${name} user secret";
            Before      = secret.dependent;
            PartOf      = secret.dependent;
          };
          Service = {
            ExecStartPre    = makeJobScript "${serviceName}-pre-start" serviceScripts.preStart;
            ExecStart       = makeJobScript "${serviceName}-start"     serviceScripts.script;
            ExecStop        = makeJobScript "${serviceName}-pre-stop"  serviceScripts.preStop;
            Type            = "oneshot";
            RemainAfterExit = "yes";
          };
          Install.RequiredBy = secret.dependent;
        });

    systemServices = mapAttrs' systemService cfg.secrets   ;
    hmServices     = mapAttrs' hmService     cfg.hm.secrets;
    systemd =
      (if systemServices != {} then { services      = systemServices; } else {}) //
      (if hmServices     != {} then { user.services = hmServices    ; } else {});
  in mkIf cfg.enable { inherit systemd; };
}
