{ pkgs, ... }:
{
  home.packages = [ pkgs.discord ];
  xdg.configFile = {
    "discord/settings.json".text =
      builtins.toJSON {
        SKIP_HOST_UPDATE   = true;
        SKIP_MODULE_UPDATE =  true;
        BACKGROUND_COLOR   = "#202225";
        OPEN_ON_STARTUP    = false;
        IS_MAXIMIZED       = true;
        IS_MINIMIZED       = false;
      };
}
