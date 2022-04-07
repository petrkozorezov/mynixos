{ pkgs, lib, config, ... }: {
  imports = [
    ./passff.nix
    ./search.nix
  ];
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

      # wallets
      solflare-wallet
      ether-metamask

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

  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    ungoogled-chromium
    torbrowser
    # nyxt
    hack-font
  ];
}
