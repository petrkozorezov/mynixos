{ pkgs, ... }:
{
  programs.firefox = {
    # enable = true;
    package = pkgs.firefox-wayland;
    # enableAdobeFlash = true;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      # ublock-origin
      # ghostery
      # https-everywhere
      # tree-style-tab
    ];
    profiles = {
      personal = {
        id        = 0;
        isDefault = true;
        settings  = {};
      };
      kubient = {
        id       = 1;
        settings = {};
      };
    };
  };
  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    chromium
    # nyxt
  ];
}
