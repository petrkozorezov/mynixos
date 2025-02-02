{ config, lib, ... }: {
  services.syncthing = {
    enable = true;
    settings = {
      devices = config.mynixos.secrets.syncthing.devices;
      folders = {
        Documents = { devices = [ "galaxy-s20u" "asrock-x300" ]; path = "~/Documents"; };
      };
    };
    openDefaultPorts = true;
  };

  mynixos.backups.snapshots.syncthing = {
    paths = [ config.services.syncthing.dataDir ];
    exclude = [ "*.tmp" ".devenv*" ".direnv*" "node_modules" ];
  };
}
