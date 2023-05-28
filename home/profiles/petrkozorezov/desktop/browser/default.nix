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
      # Automatic handling of GDPR consent forms
      consent-o-matic

      # wallets
      solflare-wallet
      ether-metamask
      # tronlink-wallet # TODO

      # ui
      tree-style-tab
      # nicer new tab tab window
      # tabliss
      # mouse-over enlarges images and displays images/videos from links
      imagus
      augmented-steam

      # work
      plantuml-visualizer

      # performance
      # Increase browser speed and reduce memory load and when you have numerous open tabs.
      auto-tab-discard

      # tools
      simple-translate
      # spell checker
      languagetool
      # site information
      flagfox
      view-page-archive
      user-agent-string-switcher
      window-titler
      epubreader

      # FIXME блокируется skip-redirect
      # image-search-options
      # search_by_image
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

        # security
        # prevent av/malware injection
        "accessibility.force_disabled" = 1;

        # performance
        # https://www.reddit.com/r/browsers/comments/nugbaw/firefox_going_up_to_1000_mb_with_only_5_tabs_open/
        "dom.ipc.processCount"                       = 0;
        "dom.ipc.processPrelaunch.enabled"           = false;
        "dom.ipc.keepProcessesAlive.privilegedabout" = 0;
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
      "ibnejdfjmmkpcnlpebklmnkoeoihofec" # TronLink
    ];
  };

  # TODO add GTK_USE_PORTAL=1
  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    # torbrowser
    # nyxt
    hack-font
  ];
}
