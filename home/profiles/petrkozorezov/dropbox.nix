{ config, ... }:
{
  # TODO disable or override firefox package
  services.dropbox = {
    enable = true;
    path   = "${config.home.homeDirectory}/Dropbox";
  };
}
