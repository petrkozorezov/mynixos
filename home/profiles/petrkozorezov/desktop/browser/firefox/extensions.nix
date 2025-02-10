{ pkgs, lib, ... }: with pkgs.firefox-addons; with lib; let
  basic = [
    # Privacy
    (ublock-origin.expectMeta {
      permissions         = [ "alarms" "dns" "menus" "privacy" "storage" "tabs" "unlimitedStorage" "webNavigation" "webRequest" "webRequestBlocking" "<all_urls>" "http://*/*" "https://*/*" "file://*/*" "https://easylist.to/*" "https://*.fanboy.co.nz/*" "https://filterlists.com/*" "https://forums.lanik.us/*" "https://github.com/*" "https://*.github.io/*" "https://github.com/uBlockOrigin/*" "https://ublockorigin.github.io/*" "https://*.reddit.com/r/uBlockOrigin/*" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    # UI
    # tabs as "tree"
    # TODO sidebery
    (tree-style-tab.expectMeta {
      permissions         = [ "activeTab" "contextualIdentities" "cookies" "menus" "menus.overrideContext" "notifications" "search" "sessions" "storage" "tabs" "theme" ];
      hostPermissions     = [ ];
      optionalPermissions = [ "<all_urls>" "bookmarks" "clipboardRead" "tabHide" ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    # performance
    # Increase browser speed and reduce memory load and when you have numerous open tabs.
    (auto-tab-discard.expectMeta {
      permissions         = [ "idle" "storage" "contextMenus" "notifications" "alarms" "*://*/*" "<all_urls>" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
  ];
in {
  inherit basic;
  all = basic ++ [
    # Privacy
    (foxyproxy-standard.expectMeta {
      permissions         = [ "downloads" "notifications" "proxy" "storage" "tabs" "webRequest" "webRequestBlocking" "<all_urls>" ];
      hostPermissions     = [ ];
      optionalPermissions = [ "browsingData" "privacy" ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    (smart-referer.expectMeta {
      permissions         = [ "menus" "storage" "theme" "webRequest" "webRequestBlocking" "*://*/*" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      requiresPayment     = false;
    })
    (skip-redirect.expectMeta {
      permissions         = [ "<all_urls>" "clipboardWrite" "contextMenus" "notifications" "storage" "webRequest" "webRequestBlocking" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      requiresPayment     = false;
    })
    (behave.expectMeta {
      permissions         = [ "webRequest" "webRequestBlocking" "notifications" "storage" "<all_urls>" "tabs" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      requiresPayment     = false;
    })
    # Automatic handling of GDPR consent forms
    (consent-o-matic.expectMeta {
      permissions         = [ "activeTab" "tabs" "storage" "<all_urls>" ];
      hostPermissions     = [ "<all_urls>" ];
      optionalPermissions = [ ];
      promotedCategory    = "notable";
      requiresPayment     = false;
    })
    (requestcontrol.expectMeta {
      permissions         = [ "<all_urls>" "storage" "webNavigation" "webRequest" "webRequestBlocking" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      requiresPayment     = false;
    })

    # wallets
    (solflare-wallet.expectMeta {
      permissions         = [ "storage" "activeTab" "tabs" "alarms" "unlimitedStorage" "<all_urls>" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "notable";
      requiresPayment     = false;
    })
    (ether-metamask.expectMeta {
      permissions         = [ "storage" "unlimitedStorage" "clipboardWrite" "http://*/*" "https://*/*" "activeTab" "webRequest" "webRequestBlocking" "*://*.eth/" "notifications" "file://*/*" "*://connect.trezor.io/*/popup.html*" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "notable";
      requiresPayment     = false;
    })
    # tronlink 5799d9b6-8343-4c26-9ab6-5d2ad39884ce
    pkgs.firefox-addons-custom.tronlink

    # UI
    # nicer new tab tab window (NOTE eats memory)
    (tabliss.expectMeta {
      permissions         = [ "storage" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    # mouse-over enlarges images and displays images/videos from links
    (imagus.expectMeta {
      permissions         = [ "*://*/*" "downloads" "history" "storage" "<all_urls>" "https://*/search*" "https://duckduckgo.com/*" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    # dark mode for every website
    (darkreader.expectMeta {
      permissions         = [ "alarms" "contextMenus" "storage" "tabs" "theme" "<all_urls>" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })

    # tools
    (firefox-translations.expectMeta {
      permissions         = [ "<all_urls>" "tabs" "webNavigation" "storage" "mozillaAddons" "contextMenus" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "line";
      requiresPayment     = false;
    })
    # spell checker
    (languagetool.expectMeta {
      permissions         = [ "activeTab" "storage" "contextMenus" "alarms" "http://*/*" "https://*/*" "file:///*" "*://docs.google.com/document/*" "*://docs.google.com/presentation/*" "*://languagetool.org/*" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      promotedCategory    = "recommended";
      requiresPayment     = false;
    })
    (passff.expectMeta {
      permissions         = [ "<all_urls>" "clipboardWrite" "contextMenus" "contextualIdentities" "nativeMessaging" "storage" "tabs" "webRequest" "webRequestBlocking" ];
      hostPermissions     = [ ];
      optionalPermissions = [ ];
      requiresPayment     = false;
    })
  ];
}
