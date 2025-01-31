# TODO add rclone to packages
{ config, ... }: {
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
}
