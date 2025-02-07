# TODO logs
# https://xeiaso.net/blog/prometheus-grafana-loki-nixos-2020-11-20/
{ config, lib, options, ... }: with lib; let
  cfg = config.mynixos.metrics;
in {
  options.mynixos.metrics = with types; {
    enable = mkEnableOption "";
    subdomain = mkOption {
      type = str;
      default = "metrics";
    };
    # пока можно без промежуточного уровня для дашбордов
  };

  config = mkIf cfg.enable {
    # prometeus
    services.prometheus = {
      enable = true;
      listenAddress = "127.0.0.1";
      retentionTime = "15d";
      globalConfig.scrape_interval = "1m";
    };

    # grafana
    services.grafana = {
      enable = true;
      settings = {
        server = {
          http_addr = "127.0.0.1";
          http_port = 3000;
          domain = config.mynixos.webserver.int.virtualHosts.${cfg.subdomain}.domain;
          enforce_domain = true;
        };
        security = {
          cookie_secure = true;
          strict_transport_security = true;
          adminUser = "admin";
          # adminPasswordFile = "/path/to/admin_password_file"; # TODO
          # secretKeyFile = "/path/to/secret_key_file";
        };
        analytics = {
          reporting_enabled = false;
          feedback_links_enabled = false;
        };
      };
      declarativePlugins = []; # not null
      provision = {
        enable = true;
        datasources.settings.datasources = [ {
          name = "Prometheus";
          type = "prometheus";
          access    =  "proxy";
          url       =  "http://${config.services.prometheus.listenAddress}:${toString config.services.prometheus.port}";
          isDefault =  true;
          editable  =  false;
        } ];
      };
    };
    # как вариант ещё можно сделать через проксирование в сокет как nixos мануале, вопрос в том, зачем?
    # https://nixos.org/manual/nixos/stable/#module-services-parsedmarc-grafana-geoip
    # TODO use postresql and backup it

    mynixos.webserver.int.virtualHosts.${cfg.subdomain} = {
      locations."/" = {
        proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
    mynixos.dns.int.subdomains = [ cfg.subdomain ];
  };
}
