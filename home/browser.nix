{ pkgs, ... }:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox-wayland;
    extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      ublock-origin
      # ghostery
      https-everywhere
      tree-style-tab
      duckduckgo-privacy-essentials
      # plantuml visualizer
    ];
    # https://github.com/piroor/treestyletab/issues/1525
    profiles = let
      settings = {
        "font.name.serif.x-western"                          = "Hack";
        "app.normandy.first_run"                             = false;
        "browser.startup.homepage"                           = "about:blank";
        "browser.aboutConfig.showWarning"                    = false;
        "browser.shell.checkDefaultBrowser"                  = false;
        "browser.search.region"                              = "RU";
        "browser.urlbar.placeholderName"                     = "DuckDuckGo";
        "browser.safebrowsing.passwords.enabled"             = true;
        "services.sync.engine.passwords"                     = false;
        "browser.contentblocking.category"                   = "strict";
        "browser.tabs.warnOnClose"                           = false;
        "browser.startup.page"                               = 3;
        "browser.sessionstore.resume_session_once"           = true;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.newtabpage.enabled"                         = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.search.suggest.enabled"                      = false;
        # "browser.search.searchEnginesURL" =
        #   "https://firefox.settings.services.mozilla.com/v1/buckets/main/collections/search-default-override-allowlist/records";
        # browser.tabs.unloadOnLowMemory
      };
      # userChrome =
      #   ''
      #    @-moz-document url("chrome://browser/content/browser.xul") {
      #      #TabsToolbar {
      #        visibility: collapse !important;
      #        margin-bottom: 21px !important;
      #      }

      #      #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
      #        visibility: collapse !important;
      #      }
      #    }
      #   '';
    in {
      personal = {
        id = 0;
        isDefault = true;
        inherit settings;
      };
      kubient = {
        id = 1;
        inherit settings;
      };
    };
  };
  home.sessionVariables.BROWSER = "firefox";
  home.packages = with pkgs; [
    pkgs.firefox-wayland
    chromium
    torbrowser
    # nyxt
  ];
}
