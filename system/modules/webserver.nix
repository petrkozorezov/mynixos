{ config, options, lib, pkgs, modulesPath, self, ... }: with lib; let
  inherit (config.mynixos) secrets;
  cfg = config.mynixos.webserver;
in {
  # абстракция тут подтекает, тк виден nginx под капотом
  options.mynixos.webserver = with types; let
    virtualHosts = zoneCfg:
      types.attrsOf (types.submodule (subArgs@{ name, ... }: { options = {
        enable = mkOption {
            type = types.bool;
            default = true;
          };
        subdomain = mkOption {
          type = str;
          default = subArgs.name; # subArgs.name doesn't work, why???
        };
        domain = mkOption {
          type = str;
          default = "${subArgs.config.subdomain}.${zoneCfg.domain}";
          readOnly = true;
        };
        locations = mkOption {
          type =
            types.attrsOf (types.submodule (import (modulesPath + "/services/web-servers/nginx/location-options.nix") {
              inherit lib config;
            }));
          default = {};
        };
      }; }));
    zoneType = submodule (subargs: { options = {
      address = mkOption {
        type = str;
      };
      domain = mkOption {
        type = str;
      };
      virtualHosts = mkOption {
        type = virtualHosts subargs.config;
        default = {};
      };
    }; });
  in {
    enable = mkEnableOption "";
    port = mkOption {
      type = port;
      default = 443;
    };
    int = mkOption { type = zoneType; };
    ext = mkOption { type = zoneType; };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.sss.enable; message = "SSS secrets system is not enabled, please enable and setup it"; }
      # TODO check int.address != ext.address
    ];

    services.nginx = {
      enable = true;

      recommendedGzipSettings  = true;
      recommendedOptimisation  = true;
      recommendedProxySettings = true;
      recommendedTlsSettings   = true;

      virtualHosts = let
        intVHost = name: vhost: {
          name  = vhost.domain;
          value = {
            inherit (vhost) locations;
            forceSSL = true;
            sslCertificate = config.sss.secrets."nginx-cert-${vhost.domain}".target;
            sslCertificateKey = config.sss.secrets.nginx-key.target;
            extraConfig = ''
              ssl_stapling off;
              '';
            listen = [ { addr = cfg.int.address; port = cfg.port; ssl = true; } ];
          };
        };
        extVHost = name: vhost: {
          name  = vhost.domain;
          value = {
            inherit (vhost) locations;
            forceSSL = true;
            enableACME = true;
            listen = [ { addr = cfg.ext.address; port = cfg.port; ssl = true; } ];
          };
        };
        vHost = vhostMapper: virtualHosts:
          (mapAttrs' vhostMapper (filterAttrs (_: vhost: vhost.enable) virtualHosts));
      in
        (vHost intVHost cfg.int.virtualHosts) //
        (vHost extVHost cfg.ext.virtualHosts);
    };

    sss.secrets = let
      baseSecret = {
        inherit (config.services.nginx) user group;
        path = "/run/nginx-keys";
        dependent = [ "nginx.service" ];
      };
      secret = name: vhost:
        let
          startYear = toInt (substring 2 2 (toString self.lastModifiedDate));
        in {
          name = "nginx-cert-${vhost.domain}";
          value = baseSecret // {
            source = pkgs.mynixos.builders.openssl.makeCert {
              key  = secrets.filesPath + "/nginx.key";
              domain = vhost.domain;
              caCrt = secrets.filesPath + "/ca.crt";
              caKey = secrets.filesPath + "/ca.key";
              # TODO ротировать сертификат почаще
              startdate = "${toString (startYear    )}0101000000Z";
              enddate   = "${toString (startYear + 2)}0101000000Z";
            };
          };
        };
      sssSecrets = mapAttrs' secret cfg.int.virtualHosts;
    in sssSecrets // {
      nginx-key = baseSecret // {
        source = secrets.filesPath + "/nginx.key";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ cfg.port ];
    };

    # TODO add metrics exporter
  };
}
