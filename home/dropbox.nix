{ config, ... }:
{
  services.dropbox = {
    enable = true;
    path   = "${config.home.homeDirectory}/Dropbox";
  };
}