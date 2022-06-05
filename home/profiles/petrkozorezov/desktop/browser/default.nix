{ pkgs, lib, config, ... }: {
  imports = [
    ./passff.nix
    ./search.nix
  ];
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    # TODO generate:
    #  - ~/.mozilla/firefox/personal/extension-preferences.json
    #  - ~/.mozilla/firefox/personal/extensions.json
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
      #sidebery # same as treestyletab TODO try

      # work
      plantuml-visualizer

      # tools
      buster-captcha-solver
      simple-translate
      languagetool # spell checker
      image-search-options
      flagfox # site information
      view-page-archive
      user-agent-string-switcher
      window-titler
    ];
    # https://github.com/piroor/treestyletab/issues/1525
    profiles = let
      baseSettings = {
        # general
        "browser.startup.page"      = 3     ; # restore session
        "font.name.serif.x-western" = "Hack"; # set my own main font
        "app.normandy.first_run"    = false ; # disable first run info (?)
        "browser.tabs.warnOnClose"  = false ; # warn on close tabs

        # search settings
        "browser.search.region"            = "RU";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.urlbar.placeholderName"   = "DuckDuckGo";
        "keyword.enabled"                  = true; # (?)

        # privacy
        "privacy.sanitize.sanitizeOnShutdown" = false; # ?
        "dom.security.https_only_mode"        = true ; # HTTPS only mode
        "network.cookie.lifetimePolicy"       = 0    ; # keep cookies between restart

        # misc
        "browser.safebrowsing.passwords.enabled"              = true ; # save passwords in safebrowsing mode
        "services.sync.engine.passwords"                      = false; # do not sync passwords
        "browser.sessionstore.resume_session_once"            = true ; # ?
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true ; # ?
      };
      arkenfoxUserJsSettings =
        # SEE https://github.com/arkenfox/user.js
        import ./generated-userjs.nix //
          (baseSettings // {
            "media.peerconnection.enabled" = false; # disable vpn detection through webrtc
          });
      userChrome = ''
        #TabsToolbar { visibility: collapse !important; }
      '';
    in {
      personal = {
        id = 0;
        isDefault = true;
        settings = arkenfoxUserJsSettings;
        inherit userChrome;
      };
      clean = {
        id = 1;
        settings = baseSettings;
        inherit userChrome;
      };
      work = {
        id = 2;
        settings = baseSettings;
        inherit userChrome;
      };
    };
  };

  programs.chromium = {
    enable = true;
    # FIXME ungoogled
    #  - google meet screen sharing
    #  - profile cleanup after restart
    #  - 2FA doesn't work
    package = pkgs.chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin    - https://github.com/gorhill/uBlock
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere - https://github.com/EFForg/https-everywhere
    ];
  };

  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    # torbrowser
    # nyxt
    hack-font
  ];
}
