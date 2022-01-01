{ config, ... }:
{
  # TODO disable or override firefox package
  services.dropbox = {
    enable = false;
    path   = "${config.home.homeDirectory}/Dropbox";
  };
}
