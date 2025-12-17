args@{ pkgs, lib, ... }: with lib; let
  importFF   = name: (import (./firefox + ("/" + name))) args;
  extensions = importFF "extensions.nix";
  settings   = importFF "settings.nix";
in {
  programs.firefox = {
    enable = true;
    package = with pkgs; (firefox.override {
      nativeMessagingHosts = [ passff-host ];
    });
    profiles = let
      baseProfile = {
        userChrome = importFF "userChrome.css.nix";
        search     = importFF "search.nix";
        settings   = settings.basic;
        extensions.packages = extensions.basic;
      };
    in {
      personal = baseProfile // {
        id = 0;
        isDefault  = true;
        settings   = settings.private;
        extensions.packages = extensions.all;
      };
      clean = baseProfile // { id = 1; };
      work  = baseProfile // { id = 2; };
    };
  };

  stylix.targets.firefox = {
    profileNames = [ "personal" ];
    # firefoxGnomeTheme.enable = true;
  };

  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http"         = "firefox.desktop";
    "x-scheme-handler/https"        = "firefox.desktop";
    "x-scheme-handler/ftp"          = "firefox.desktop";
    "x-scheme-handler/chrome"       = "firefox.desktop";
    "text/html"                     = "firefox.desktop";
    "application/x-extension-htm"   = "firefox.desktop";
    "application/x-extension-html"  = "firefox.desktop";
    "application/x-extension-shtml" = "firefox.desktop";
    "application/xhtml+xml"         = "firefox.desktop";
    "application/x-extension-xhtml" = "firefox.desktop";
    "application/x-extension-xht"   = "firefox.desktop";
  };
}
