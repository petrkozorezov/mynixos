# -MOZ_LOG=all:3 # info
args@{ pkgs, lib, config, deps, ... }: let
  acceptedExtensions = import ./firefox/extensions.nix;
  extensions = map (name: pkgs.firefox-addons.${name}) (lib.attrNames acceptedExtensions);
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
  # TODO upstream in a common way
  assertions = lib.mapAttrsToList (name: permissions: let
      unaccepted = lib.subtractLists permissions pkgs.firefox-addons.${name}.meta.permissions;
    in {
      assertion = unaccepted == [];
      message = "Extension ${name} has unaccepted permissions: ${builtins.toJSON unaccepted}";
    }) acceptedExtensions;

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
        inherit userChrome extensions search;
      };
      work = {
        id = 2;
        settings = baseSettings;
        inherit userChrome extensions search;
      };
    };
  };
}
