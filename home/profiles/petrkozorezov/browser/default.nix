{ pkgs, lib, config, ... }:
  with lib;
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.firefox-addons; [

      # privacy
      ublock-origin
      foxyproxy-standard
      smart-referer
      skip-redirect
      change-timezone-time-shift
      behave

      # ui
      tree-style-tab

      # work
      plantuml-visualizer
    ];
    # https://github.com/piroor/treestyletab/issues/1525
    profiles = let
      settings =
        # SEE https://github.com/arkenfox/user.js
        import ./generated-userjs.nix //
          {
            # restore session
            "browser.startup.page" = 3;
            # set my own main font
            "font.name.serif.x-western" = "Hack";
            # ?
            "app.normandy.first_run" = false;

            # serch
            # set region
            "browser.search.region"            = "RU";
            "browser.search.defaultenginename" = "DuckDuckGo";
            "browser.urlbar.placeholderName"   = "DuckDuckGo";
            "keyword.enabled"                  = true;

            # ?
            "browser.safebrowsing.passwords.enabled"              = true;
            "services.sync.engine.passwords"                      = false;
            "browser.tabs.warnOnClose"                            = false;
            "browser.sessionstore.resume_session_once"            = true;
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

            # privacy
            "privacy.sanitize.sanitizeOnShutdown" = false;
            # disable vpn detection through webrtc
            "media.peerconnection.enabled"  = false;
            # HTTPS only mode
            "dom.security.https_only_mode"  = true;
            # keep cookies between restart
            "network.cookie.lifetimePolicy" = 0;
          };
    in {
      personal = {
        id = 0;
        isDefault = true;
        inherit settings;
      };
    };
  };

  # TODO generate search.json
  home.file =
    let
      profilesPath = ".mozilla/firefox"; # TODO get from appropriate place
      searchJson   = ./search.json;
    in
      mapAttrs'
        (name: profile:
          nameValuePair "${profilesPath}/${profile.path}/search.json.mozlz4" {
            source = pkgs.runCommandLocal "firefox-${name}-search.json" {} "${pkgs.mozlz4a}/bin/mozlz4a ${searchJson} $out";
          }
        )
        config.programs.firefox.profiles;

  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    chromium
    torbrowser
    # nyxt
  ];
}
