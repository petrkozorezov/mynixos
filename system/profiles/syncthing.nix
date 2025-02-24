{ config, lib, ... }: with lib; {
  services.syncthing = {
    enable = true;
    settings = {
      devices = config.mynixos.secrets.syncthing.devices;
      folders = mapAttrs (name: folder: { path = "~/${name}"; } // folder) config.mynixos.secrets.syncthing.folders;
    };
    openDefaultPorts = true;
  };

  mynixos.backups.snapshots.syncthing = {
    paths = [ config.services.syncthing.dataDir ];
    exclude = [ "*.tmp" ".devenv*" ".direnv*" "node_modules" ];
  };

  mynixos.dns.ext.subdomains = [ "sync" ];
}
