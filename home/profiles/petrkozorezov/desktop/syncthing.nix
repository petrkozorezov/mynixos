{ slib, ... }: let
  syncthing =
    slib.syncthing.configuration.host config.networking.hostname config.zoo.syncthing;
in
{
  options.zoo.syncthing = syncthing.types.configuration;

  # systemd.services = syncthing.services;
  # sss.secrets      = syncthing.secrets;
  # environment.etc  = syncthing.files;
  config = {
    # services.syncthing = {
    #   enable       = true;
    #   extraOptions = options;
    #   tray.enable  = true;
    # };
    systemd.user.services = syncthing.services;
    sss.user.secrets      = syncthing.secrets;
    home.file             = syncthing.files;
  };
}
