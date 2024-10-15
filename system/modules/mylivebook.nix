{ pkgs, config, lib, ... }:
with lib;
let
  cfg = config.services.mylivebook;
in {
  options.services = {
    mylivebook = {

      enable = mkEnableOption "livebook";

      package = mkOption {
        description = "livebook package to use";
        type        = types.package;
        default     = pkgs.livebook;
      };

      user = mkOption {
        description = "user to run from";
        type        = types.str;
        default     = "livebook";
      };

      group = mkOption {
        description = "group to run from";
        type        = types.str;
        default     = config.users.users."${cfg.user}".group;
      };

      openFirewall = mkOption {
        description = "whether to open firewall";
        type        = types.bool;
        default     = true;
      };

      settings = {
        erlangFlags = mkOption {
          type        = with types; listOf str;
          default     = [];
          description = "additional flags to run erlang node";
          example     = [ "-proto_dist inet6_tcp" ];
        };

        distribution = {
          type = mkOption {
            type        = with types; nullOr (enum [ "name" "sname" ]);
            default     = null;
            description = "node distribution type";
          };

          name = mkOption {
            type        = with types; nullOr str;
            default     = null;
            description = "node name";
          };

          cookie = mkOption {
            type        = with types; nullOr str;
            default     = null;
            description = "node cookie, a random string is generated on boot if not set";
            example     = "very-secret-cookie";
          };
        };

        iframe = {
          port = mkOption {
            type        = types.port;
            default     = 8081;
            description = "the port that Livebook serves iframes at. This is relevant only when running Livebook without TLS";
          };
          url = mkOption {
            type        = with types; nullOr str;
            default     = null;
            description = "the URL that Livebook loads iframes from. By default iframes are loaded from local port when accessing Livebook over http:// and from https://livebookusercontent.com when accessing over https://";
          };
        };

        home = mkOption {
          type        = types.path;
          default     = config.users.users."${cfg.user}".home;
          description = "path to notebooks home";
        };

        dataPath = mkOption {
          type        = types.path;
          default     = "${cfg.settings.home}/livebook";
          description = "the directory to store Livebook configuration";
        };

        baseUrl = mkOption {
          type        = with types; nullOr str;
          description = "base url to livebook server, useful when deploying behind a reverse proxy";
          default     = null;
          example     = "https://yourserver.com/";
        };

        defaultRuntime = mkOption {
          type = with types; oneOf [
            (enum [ "standalone" "embedded"  ])
            (strMatching "attached:[^\\:]:[^\\:]") # TODO
          ];
          default     = "standalone";
          description = "runtime type that is used by default when none is started explicitly for the given notebook";
        };

        ip = mkOption {
          type        = types.str;
          default     = "0.0.0.0";
          description = "the ip address to start the web application on";
        };

        port = mkOption {
          type        = types.port;
          default     = 8080;
          description = "the port runs on, if set to 0, a random port will be picked";
        };

        passwordFile = mkOption {
          type        = with types; nullOr str;
          default     = null;
          description = "sets a password file that must be used to access; must be at least 12 characters";
        };

        secretKeyBaseFile = mkOption {
          type        = with types; nullOr str;
          default     = null;
          description = ''
            Sets a secret key file that is used to sign and encrypt the session and other payloads used by Livebook.
            Must be at least 64 characters long and it can be generated by commands such as: 'openssl rand -base64 48'.
            A random secret is used on every boot if not set
          '';
        };
      };

      extraEnv = mkOption {
        type        = types.attrs;
        default     = {};
        description = "extra environment to pass to livebook";
      };
    };
  };
  config = mkIf cfg.enable (mkMerge [
    {
      users.users."${cfg.user}" = mkDefault {
        name         = cfg.user;
        isNormalUser = true;
      };
      systemd.services.mylivebook = {
        description   = "Livebook server";
        wantedBy      = [ "multi-user.target" ];
        after         = [ "network.target" ];
        path          = [ "" ]; # HACK "/bin" not in the PATH by default, but os_mon needs it
        preStart      = "${pkgs.coreutils}/bin/mkdir -p ${cfg.settings.dataPath }";
        script = let
          passwordFile      = cfg.settings.passwordFile;
          secretKeyBaseFile = cfg.settings.secretKeyBaseFile;
        in
          (optionalString (passwordFile      != null)        "LIVEBOOK_PASSWORD=\"`cat ${passwordFile     }`\"") + " " +
          (optionalString (secretKeyBaseFile != null) "LIVEBOOK_SECRET_KEY_BASE=\"`cat ${secretKeyBaseFile}`\"") + " " +
          "${cfg.package}/bin/livebook start";
        serviceConfig = {
          Type             = "simple";
          Restart          = "always";
          RestartSec       = "5";
          User             = cfg.user;
          Group            = cfg.group;
          WorkingDirectory = cfg.settings.home;
        };
        environment = with cfg.settings; mkMerge [
          {
            ERL_AFLAGS               = concatStringsSep " " erlangFlags;
            LIVEBOOK_IFRAME_PORT     = toString iframe.port;
            LIVEBOOK_HOME            = home           ;
            LIVEBOOK_DATA_PATH       = dataPath       ;
            LIVEBOOK_DEFAULT_RUNTIME = defaultRuntime ;
            LIVEBOOK_IP              = ip             ;
            LIVEBOOK_PORT            = toString port  ;
          }
          (mkIf (distribution.type   != null) { LIVEBOOK_DISTRIBUTION    = distribution.type  ; })
          (mkIf (baseUrl             != null) { LIVEBOOK_BASE_URL_PATH   = baseUrl            ; })
          (mkIf (distribution.name   != null) { LIVEBOOK_NODE            = distribution.name  ; })
          (mkIf (distribution.cookie != null) { LIVEBOOK_COOKIE          = distribution.cookie; })
          (mkIf (iframe.url          != null) { LIVEBOOK_IFRAME_URL      = iframe.url         ; })
          cfg.extraEnv
        ];
      };
    }
    (mkIf (cfg.openFirewall) {
      networking.firewall.allowedTCPPorts = [
        cfg.settings.port
        cfg.settings.iframe.port
      ];
    })
  ]);
}