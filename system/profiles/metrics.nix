{ config, lib, ... }: with lib; {
  mynixos.metrics.enable = true;

  # TODO это место пока не доделано, для одной ноды пойдёт, но для кластерной конфигурации уже нет
  #  нужно сделать чтобы задавать это в одном месте в случае
  services.prometheus.exporters.node = {
    enable = true;
    port   = mkDefault 9000;
    enabledCollectors = [ "systemd" "logind" ];
    listenAddress = mkDefault "127.0.0.1"; # TODO replace in server config
  };
  services.prometheus.scrapeConfigs = [ {
    job_name = "node";
    static_configs = [ {
      labels.instance = "localhost"; # FIXME сделать тут нормальных hostame
      targets = [
        "${toString config.services.prometheus.exporters.node.listenAddress}:${toString config.services.prometheus.exporters.node.port}"
      ];
    } ];
  } ];
}
