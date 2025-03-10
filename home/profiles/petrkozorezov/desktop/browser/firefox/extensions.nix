{ pkgs, lib, ... }: with pkgs.firefox-addons; with lib; let
  baseAllowance = {
    permissions         = [];
    hostPermissions     = [];
    optionalPermissions = [];
    requiresPayment     = false;
  };
  basic = [
    # Privacy
    # AD blocker
    (ublock-origin.allow (baseAllowance // {
      permissions      = [ "alarms" "dns" "menus" "privacy" "storage" "tabs" "unlimitedStorage" "webNavigation" "webRequest" "webRequestBlocking" "<all_urls>" "http://*/*" "https://*/*" "file://*/*" "https://easylist.to/*" "https://*.fanboy.co.nz/*" "https://filterlists.com/*" "https://forums.lanik.us/*" "https://github.com/*" "https://*.github.io/*" "https://github.com/uBlockOrigin/*" "https://ublockorigin.github.io/*" "https://*.reddit.com/r/uBlockOrigin/*" ];
      # promotedCategory = "recommended";
    }))
    # UI
    # tabs as "tree"
    (tree-style-tab.allow (baseAllowance // {
      permissions         = [ "activeTab" "contextualIdentities" "cookies" "menus" "menus.overrideContext" "notifications" "search" "sessions" "storage" "tabs" "theme" ];
      optionalPermissions = [ "<all_urls>" "bookmarks" "clipboardRead" "tabHide" ];
      # promotedCategory    = "recommended";
    }))
    # performance
    # Increase browser speed and reduce memory load and when you have numerous open tabs.
    (auto-tab-discard.allow (baseAllowance // {
      permissions      = [ "idle" "storage" "contextMenus" "notifications" "alarms" "*://*/*" "<all_urls>" ];
      # promotedCategory = "recommended";
    }))
  ];
in {
  inherit basic;
  all = basic ++ [
    # Privacy
    # Proxy manager.
    (foxyproxy-standard.allow (baseAllowance // {
      permissions         = [ "downloads" "notifications" "proxy" "storage" "tabs" "webRequest" "webRequestBlocking" "<all_urls>" ];
      optionalPermissions = [ "browsingData" "privacy" ];
      # promotedCategory    = "recommended";
    }))
    # This webextension tries to extract the final url from the intermediary url and goes there straight away if successful.
    (skip-redirect.allow (baseAllowance // {
      permissions = [ "<all_urls>" "clipboardWrite" "contextMenus" "notifications" "storage" "webRequest" "webRequestBlocking" ];
    }))
    # Behave! monitors and warn if a web page performs any of following actions:
    # - DNS Rebinding attacks to Private IPs;
    # - Access to Private IPs;
    # - Browser based Port Scan.
    (behave.allow (baseAllowance // {
      permissions = [ "webRequest" "webRequestBlocking" "notifications" "storage" "<all_urls>" "tabs" ];
    }))
    # Automatic handling of GDPR consent forms.
    (consent-o-matic.allow (baseAllowance // {
      permissions      = [ "activeTab" "tabs" "storage" "<all_urls>" ];
      hostPermissions  = [ "<all_urls>" ];
      # promotedCategory = "notable";
    }))
    (istilldontcareaboutcookies.allow (baseAllowance // {
        permissions      = [ "tabs" "storage" "http://*/*" "https://*/*" "notifications" "webRequest" "webRequestBlocking" "webNavigation" ];
        # promotedCategory = "notable";
    }))
    # Removes tracking elements from URLs.
    (clearurls.allow (baseAllowance // {
      permissions         = [ "<all_urls>" "webRequest" "webRequestBlocking" "storage" "unlimitedStorage" "contextMenus" "webNavigation" "tabs" "downloads" "*://*.google.com/*" "*://*.google.ad/*" "*://*.google.ae/*" "*://*.google.com.af/*" "*://*.google.com.ag/*" "*://*.google.com.ai/*" "*://*.google.al/*" "*://*.google.am/*" "*://*.google.co.ao/*" "*://*.google.com.ar/*" "*://*.google.as/*" "*://*.google.at/*" "*://*.google.com.au/*" "*://*.google.az/*" "*://*.google.ba/*" "*://*.google.com.bd/*" "*://*.google.be/*" "*://*.google.bf/*" "*://*.google.bg/*" "*://*.google.com.bh/*" "*://*.google.bi/*" "*://*.google.bj/*" "*://*.google.com.bn/*" "*://*.google.com.bo/*" "*://*.google.com.br/*" "*://*.google.bs/*" "*://*.google.bt/*" "*://*.google.co.bw/*" "*://*.google.by/*" "*://*.google.com.bz/*" "*://*.google.ca/*" "*://*.google.cd/*" "*://*.google.cf/*" "*://*.google.cg/*" "*://*.google.ch/*" "*://*.google.ci/*" "*://*.google.co.ck/*" "*://*.google.cl/*" "*://*.google.cm/*" "*://*.google.cn/*" "*://*.google.com.co/*" "*://*.google.co.cr/*" "*://*.google.com.cu/*" "*://*.google.cv/*" "*://*.google.com.cy/*" "*://*.google.cz/*" "*://*.google.de/*" "*://*.google.dj/*" "*://*.google.dk/*" "*://*.google.dm/*" "*://*.google.com.do/*" "*://*.google.dz/*" "*://*.google.com.ec/*" "*://*.google.ee/*" "*://*.google.com.eg/*" "*://*.google.es/*" "*://*.google.com.et/*" "*://*.google.fi/*" "*://*.google.com.fj/*" "*://*.google.fm/*" "*://*.google.fr/*" "*://*.google.ga/*" "*://*.google.ge/*" "*://*.google.gg/*" "*://*.google.com.gh/*" "*://*.google.com.gi/*" "*://*.google.gl/*" "*://*.google.gm/*" "*://*.google.gp/*" "*://*.google.gr/*" "*://*.google.com.gt/*" "*://*.google.gy/*" "*://*.google.com.hk/*" "*://*.google.hn/*" "*://*.google.hr/*" "*://*.google.ht/*" "*://*.google.hu/*" "*://*.google.co.id/*" "*://*.google.ie/*" "*://*.google.co.il/*" "*://*.google.im/*" "*://*.google.co.in/*" "*://*.google.iq/*" "*://*.google.is/*" "*://*.google.it/*" "*://*.google.je/*" "*://*.google.com.jm/*" "*://*.google.jo/*" "*://*.google.co.jp/*" "*://*.google.co.ke/*" "*://*.google.com.kh/*" "*://*.google.ki/*" "*://*.google.kg/*" "*://*.google.co.kr/*" "*://*.google.com.kw/*" "*://*.google.kz/*" "*://*.google.la/*" "*://*.google.com.lb/*" "*://*.google.li/*" "*://*.google.lk/*" "*://*.google.co.ls/*" "*://*.google.lt/*" "*://*.google.lu/*" "*://*.google.lv/*" "*://*.google.com.ly/*" "*://*.google.co.ma/*" "*://*.google.md/*" "*://*.google.me/*" "*://*.google.mg/*" "*://*.google.mk/*" "*://*.google.ml/*" "*://*.google.com.mm/*" "*://*.google.mn/*" "*://*.google.ms/*" "*://*.google.com.mt/*" "*://*.google.mu/*" "*://*.google.mv/*" "*://*.google.mw/*" "*://*.google.com.mx/*" "*://*.google.com.my/*" "*://*.google.co.mz/*" "*://*.google.com.na/*" "*://*.google.com.nf/*" "*://*.google.com.ng/*" "*://*.google.com.ni/*" "*://*.google.ne/*" "*://*.google.nl/*" "*://*.google.no/*" "*://*.google.com.np/*" "*://*.google.nr/*" "*://*.google.nu/*" "*://*.google.co.nz/*" "*://*.google.com.om/*" "*://*.google.com.pa/*" "*://*.google.com.pe/*" "*://*.google.com.pg/*" "*://*.google.com.ph/*" "*://*.google.com.pk/*" "*://*.google.pl/*" "*://*.google.pn/*" "*://*.google.com.pr/*" "*://*.google.ps/*" "*://*.google.pt/*" "*://*.google.com.py/*" "*://*.google.com.qa/*" "*://*.google.ro/*" "*://*.google.ru/*" "*://*.google.rw/*" "*://*.google.com.sa/*" "*://*.google.com.sb/*" "*://*.google.sc/*" "*://*.google.se/*" "*://*.google.com.sg/*" "*://*.google.sh/*" "*://*.google.si/*" "*://*.google.sk/*" "*://*.google.com.sl/*" "*://*.google.sn/*" "*://*.google.so/*" "*://*.google.sm/*" "*://*.google.sr/*" "*://*.google.st/*" "*://*.google.com.sv/*" "*://*.google.td/*" "*://*.google.tg/*" "*://*.google.co.th/*" "*://*.google.com.tj/*" "*://*.google.tk/*" "*://*.google.tl/*" "*://*.google.tm/*" "*://*.google.tn/*" "*://*.google.to/*" "*://*.google.com.tr/*" "*://*.google.tt/*" "*://*.google.com.tw/*" "*://*.google.co.tz/*" "*://*.google.com.ua/*" "*://*.google.co.ug/*" "*://*.google.co.uk/*" "*://*.google.com.uy/*" "*://*.google.co.uz/*" "*://*.google.com.vc/*" "*://*.google.co.ve/*" "*://*.google.vg/*" "*://*.google.co.vi/*" "*://*.google.com.vn/*" "*://*.google.vu/*" "*://*.google.ws/*" "*://*.google.rs/*" "*://*.google.co.za/*" "*://*.google.co.zm/*" "*://*.google.co.zw/*" "*://*.google.cat/*" "*://*.yandex.ru/*" "*://*.yandex.com/*" "*://*.ya.ru/*" ];
      # promotedCategory    = "recommended";
    }))
    (private-relay.allow (baseAllowance // {
      permissions      = [ "<all_urls>" "storage" "menus" "contextMenus" "https://relay.firefox.com/" "https://relay.firefox.com/**" "https://relay.firefox.com/accounts/profile/**" "https://relay.firefox.com/accounts/settings/**" ];
      # promotedCategory = "line";
    }))

    # wallets
    (solflare-wallet.allow (baseAllowance // {
      permissions      = [ "storage" "activeTab" "tabs" "alarms" "unlimitedStorage" "<all_urls>" ];
      # promotedCategory = "notable";
    }))
    (ether-metamask.allow (baseAllowance // {
      permissions      = [ "storage" "unlimitedStorage" "clipboardWrite" "http://*/*" "https://*/*" "activeTab" "webRequest" "webRequestBlocking" "*://*.eth/" "notifications" "file://*/*" "*://connect.trezor.io/*/popup.html*" ];
      # promotedCategory = "notable";
    }))
    # tronlink 5799d9b6-8343-4c26-9ab6-5d2ad39884ce
    pkgs.firefox-addons-custom.tronlink

    # UI
    # Nicer new tab page (NOTE eats memory).
    (tabliss.allow (baseAllowance // {
      permissions      = [ "storage" ];
      # promotedCategory = "recommended";
    }))
    # Mouse-over enlarges images and displays images/videos from links.
    (imagus.allow (baseAllowance // {
      permissions      = [ "*://*/*" "downloads" "history" "storage" "<all_urls>" "https://*/search*" "https://duckduckgo.com/*" ];
      # promotedCategory = "recommended";
    }))
    # Dark mode for every website.
    (darkreader.allow (baseAllowance // {
      permissions      = [ "alarms" "contextMenus" "storage" "tabs" "theme" "<all_urls>" ];
      # promotedCategory = "recommended";
    }))
    (macos-big-sur-dark-mode.allow (baseAllowance // {}))
    # (reddarkmode.allow (baseAllowance // {}))

    # tools
    # translators
    (firefox-translations.allow (baseAllowance // {
      permissions      = [ "<all_urls>" "tabs" "webNavigation" "storage" "mozillaAddons" "contextMenus" ];
      # promotedCategory = "line";
    }))
    (simple-translate.allow (baseAllowance // {
      permissions      = [ "storage" "contextMenus" "http://*/*" "https://*/*" "<all_urls>" ];
      # promotedCategory = "recommended";
    }))
    # spell checker
    (languagetool.allow (baseAllowance // {
      permissions      = [ "activeTab" "storage" "contextMenus" "alarms" "http://*/*" "https://*/*" "file:///*" "*://docs.google.com/document/*" "*://docs.google.com/presentation/*" "*://languagetool.org/*" ];
      # promotedCategory = "recommended";
    }))
    (passff.allow (baseAllowance // {
      permissions = [ "<all_urls>" "clipboardWrite" "contextMenus" "contextualIdentities" "nativeMessaging" "storage" "tabs" "webRequest" "webRequestBlocking" ];
    }))
    (deep-fake-detector.allow (baseAllowance // {
      hostPermissions  = [ "http://*/*" "https://*/*" ];
      permissions      = [ "unlimitedStorage" "activeTab" "storage" "contextMenus" "<all_urls>" ];
      # promotedCategory = "line";
    }))
    (fakespot-fake-reviews-amazon.allow (baseAllowance // {
      permissions      = ["identity" "unlimitedStorage" "http://*/*" "https://*/*" "activeTab" "tabs" "storage" "cookies" "*://*.fakespot.com/*" "*://*.fakespot.local/*" "*://*.amazon.com.au/*" "*://*.amazon.co.uk/*" "*://*.amazon.ca/*" "*://*.amazon.us/*" "*://*.amazon.com/*" "*://*.amazon.in/*" "*://*.amazon.de/*" "*://*.amazon.fr/*" "*://*.amazon.it/*" "*://*.amazon.es/*" "*://*.amazon.co.jp/*" "*://*.ebay.com/*" "*://*.ebay.co.uk/*" "*://*.ebay.com.au/*" "*://*.ebay.us/*" "*://*.ebay.ca/*" "*://*.walmart.com/*" "*://*.google.com/search*" "*://*.bestbuy.com/*" "*://*.sephora.com/*" "*://*.flipkart.com/*" "*://*.flipkart.in/*" "*://*.homedepot.com/*" "<all_urls>" ];
      # promotedCategory = "line";
    }))
    (return-youtube-dislikes.allow (baseAllowance // {
      permissions      = [ "activeTab" "*://*.youtube.com/*" "storage" "*://returnyoutubedislikeapi.com/*" ];
      # promotedCategory = "recommended";
    }))
    (web-clipper-obsidian.allow (baseAllowance // {
      permissions      = [ "activeTab" "clipboardWrite" "contextMenus" "storage" "scripting" "http://*/*" "https://*/*" ];
      hostPermissions  = [ "<all_urls>" "http://*/*" "https://*/*" ];
      # promotedCategory = "notable";
    }))
  ];
}
