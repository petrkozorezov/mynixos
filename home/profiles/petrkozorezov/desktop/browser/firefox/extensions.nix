{
  ublock-origin = [ "alarms" "dns" "menus" "privacy" "storage" "tabs" "unlimitedStorage" "webNavigation" "webRequest" "webRequestBlocking" "<all_urls>" "http://*/*" "https://*/*" "file://*/*" "https://easylist.to/*" "https://*.fanboy.co.nz/*" "https://filterlists.com/*" "https://forums.lanik.us/*" "https://github.com/*" "https://*.github.io/*" "https://github.com/uBlockOrigin/*" "https://ublockorigin.github.io/*" "https://*.reddit.com/r/uBlockOrigin/*" ];
  foxyproxy-standard = [ "downloads" "notifications" "proxy" "storage" "tabs" "webRequest" "webRequestBlocking" "<all_urls>" ];
  smart-referer = [ "menus" "storage" "theme" "webRequest" "webRequestBlocking" "*://*/*" ];
  skip-redirect = [ "<all_urls>" "clipboardWrite" "contextMenus" "notifications" "storage" "webRequest" "webRequestBlocking" ];
  behave = [ "webRequest" "webRequestBlocking" "notifications" "storage" "<all_urls>" "tabs" ];
  # Automatic handling of GDPR consent forms
  consent-o-matic = [ "activeTab" "tabs" "storage" "<all_urls>" ];
  requestcontrol = [ "<all_urls>" "storage" "webNavigation" "webRequest" "webRequestBlocking" ];

  # wallets
  solflare-wallet = [ "storage" "activeTab" "tabs" "alarms" "unlimitedStorage" "<all_urls>" ];
  ether-metamask = [ "storage" "unlimitedStorage" "clipboardWrite" "http://*/*" "https://*/*" "activeTab" "webRequest" "webRequestBlocking" "*://*.eth/" "notifications" "file://*/*" "*://connect.trezor.io/*/popup.html*" ];
  # tronlink-wallet # TODO

  # ui
  # tabs as "tree"
  tree-style-tab = [ "activeTab" "contextualIdentities" "cookies" "menus" "menus.overrideContext" "notifications" "search" "sessions" "storage" "tabs" "theme" ]; # TODO sidebery
  # nicer new tab tab window (NOTE eats memory)
  tabliss = [ "storage" ];
  # mouse-over enlarges images and displays images/videos from links
  imagus = [ "*://*/*" "downloads" "history" "storage" "<all_urls>" "https://*/search*" "https://duckduckgo.com/*" ];
  # dark mode for every website
  darkreader = [ "alarms" "contextMenus" "storage" "tabs" "theme" "<all_urls>" ];

  # performance
  # Increase browser speed and reduce memory load and when you have numerous open tabs.
  auto-tab-discard = [ "idle" "storage" "contextMenus" "notifications" "alarms" "*://*/*" "<all_urls>" ];

  # tools
  firefox-translations = [ "<all_urls>" "tabs" "webNavigation" "storage" "mozillaAddons" "contextMenus" ];
  # spell checker
  languagetool = [ "activeTab" "storage" "contextMenus" "alarms" "http://*/*" "https://*/*" "file:///*" "*://docs.google.com/document/*" "*://docs.google.com/presentation/*" "*://languagetool.org/*" ];
  passff = [ "<all_urls>" "clipboardWrite" "contextMenus" "contextualIdentities" "nativeMessaging" "storage" "tabs" "webRequest" "webRequestBlocking" ];
}
