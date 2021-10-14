{ pkgs, ... }:
{
    home.packages = with pkgs; [ vkquake ];
    xdg.configFile.".vkquake/id1/config.cfg".source = ./quake.cfg;
}
