args@{ pkgs, lib, config, deps, ... }: let
  extensions = (import ./firefox/extensions.nix) args;
  baseSettings = import ./firefox/settings.nix;
  arkenfoxUserJsSettings =
    deps.inputs.arkenfox-userjs.lib //
      (baseSettings // {
        "media.peerconnection.enabled" = false; # disable vpn detection through webrtc
      });
  userChrome = ''
    #TabsToolbar { visibility: collapse !important; }
  '';
  search = (import ./firefox/search.nix) args;
in {
  programs.firefox = {
    enable = true;
    package = with pkgs; (firefox-wayland.override {
      nativeMessagingHosts = [
        passff-host
        browserpass
      ];
    });
    # TODO generate:
    #  - ~/.mozilla/firefox/personal/extension-preferences.json
    #  - ~/.mozilla/firefox/personal/extensions.json
    # https://github.com/piroor/treestyletab/issues/1525
    profiles = {
      personal = {
        id = 0;
        isDefault = true;
        settings = arkenfoxUserJsSettings;
        inherit userChrome extensions search;
      };
      clean = {
        id = 1;
        settings = baseSettings;
        inherit userChrome search;
      };
      work = {
        id = 2;
        settings = arkenfoxUserJsSettings;
        inherit userChrome extensions search;
      };
    };
  };
}
