# -MOZ_LOG=all:3 # info
{ pkgs, lib, config, deps, ... }: {
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
    profiles = let
      extensions = with pkgs.firefox-addons; [ # TODO use pkgs.nur.repos.rycee.firefox-addons
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
        # tabs as "tree"
        tree-style-tab # TODO sidebery
        # nicer new tab tab window (NOTE eats memory)
        tabliss
        # mouse-over enlarges images and displays images/videos from links
        imagus
        augmented-steam

        # work
        plantuml-visualizer

        # performance
        # Increase browser speed and reduce memory load and when you have numerous open tabs.
        auto-tab-discard

        # tools
        firefox-translations
        # spell checker
        languagetool
        # site information
        flagfox
        view-page-archive
        user-agent-string-switcher
        window-titler
        epubreader

        passff
        browserpass-ce

        # libredirect # TODO

        # FIXME блокируется skip-redirect
        # image-search-options
        # search_by_image
      ];
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
        deps.inputs.arkenfox-userjs.lib //
          (baseSettings // {
            "media.peerconnection.enabled" = false; # disable vpn detection through webrtc
          });
      userChrome = ''
        #TabsToolbar { visibility: collapse !important; }
      '';
      search = {
        default        = "DuckDuckGo";
        privateDefault = "DuckDuckGo";
        force          = true;
        order          = [ "DuckDuckGo" "Google" "Yandex" "Wikipedia (en)" ]; # TODO
        engines = {
          "DuckDuckGo".metaData.alias     = ".d";
          "Google".metaData.alias         = ".g";
          "Yandex".metaData.alias         = ".y";
          "Wikipedia (en)".metaData.alias = ".w";
          "Amazon.com".metaData.hidden    = true;
          "Bing".metaData.hidden          = true;

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ ".nsp" ];
          };

          "NixOS Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ ".nso" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ ".nsw" ];
          };

          "HexDocs" = {
            urls = [{ template = "https://hexdocs.pm/{searchTerms}"; }];
            # TODO icon
            definedAliases = [ ".hd" ];
          };

          "HexDocs Elixir" = {
            urls = [{
              template = "https://hexdocs.pm/elixir/search.html";
              params = [{ name = "q"; value = "{searchTerms}"; }];
            }];
            # TODO icon
            definedAliases = [ ".hde" ];
          };

          # TODO add google/yandex translate (gt/yt) and mb chatgpt, noogle.dev (noo), home-manager (nhm) (where?)
        };
      };
    in {
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

  home.sessionVariables.BROWSER = "firefox";
  home.sessionVariables.GTK_USE_PORTAL = "1"; # TODO set it specifically for ff
  home.packages = with pkgs; [
    # torbrowser
    # nyxt
    hack-font
  ];
}

# F1 -- open hide tree style tab
