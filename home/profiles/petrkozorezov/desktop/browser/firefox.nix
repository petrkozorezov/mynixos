args@{ pkgs, lib, ... }: with lib; let
  importFF   = name: (import (./firefox + ("/" + name))) args;
  extensions = importFF "extensions.nix";
  settings   = importFF "settings.nix";
in {
  programs.firefox = {
    enable = true;
    package = with pkgs; (firefox-wayland.override {
      nativeMessagingHosts = [ passff-host ];
    });
    profiles = let
      baseProfile = {
        userChrome = importFF "userChrome.css.nix";
        search     = importFF "search.nix";
        settings   = settings.basic;
        extensions = extensions.basic;
      };
    in {
      personal = baseProfile // {
        id = 0;
        isDefault  = true;
        settings   = settings.private;
        extensions = extensions.all;
      };
      clean = baseProfile // { id = 1; };
      work  = baseProfile // { id = 2; };
    };
  };
}
