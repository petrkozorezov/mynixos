{ config, ... }:
{
  services.dropbox = {
    enable = false;
    path   = "${config.home.homeDirectory}/Dropbox";
  };
}
