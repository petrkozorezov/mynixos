{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "augmented-steam" = buildFirefoxXpiAddon {
      pname = "augmented-steam";
      version = "2.6.0";
      addonId = "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4167723/augmented_steam-2.6.0.xpi";
      sha256 = "949f9f8c8a932cbaee3fea6ccbb25a34fa1d260c61df78e5c384bdf7d4118c59";
      meta = with lib;
      {
        homepage = "https://augmentedsteam.com/";
        description = "Augments your Steam Experience";
        license = licenses.gpl3;
        mozPermissions = [
          "storage"
          "*://*.steampowered.com/*"
          "*://steamcommunity.com/*"
          "*://*.isthereanydeal.com/"
          "webRequest"
          "webRequestBlocking"
          "contextMenus"
          "*://store.steampowered.com/?*"
          "*://store.steampowered.com/"
          "*://*.steampowered.com/wishlist/id/*"
          "*://*.steampowered.com/wishlist/profiles/*"
          "*://*.steampowered.com/charts/*"
          "*://*.steampowered.com/charts"
          "*://*.steampowered.com/charts?*"
          "*://*.steampowered.com/search/*"
          "*://*.steampowered.com/search"
          "*://*.steampowered.com/search?*"
          "*://*.steampowered.com/steamaccount/addfunds"
          "*://*.steampowered.com/steamaccount/addfunds?*"
          "*://*.steampowered.com/steamaccount/addfunds/"
          "*://*.steampowered.com/steamaccount/addfunds/?*"
          "*://*.steampowered.com/digitalgiftcards/selectgiftcard"
          "*://*.steampowered.com/digitalgiftcards/selectgiftcard?*"
          "*://*.steampowered.com/digitalgiftcards/selectgiftcard/"
          "*://*.steampowered.com/digitalgiftcards/selectgiftcard/?*"
          "*://*.steampowered.com/account"
          "*://*.steampowered.com/account?*"
          "*://*.steampowered.com/account/"
          "*://*.steampowered.com/account/?*"
          "*://store.steampowered.com/account/licenses"
          "*://store.steampowered.com/account/licenses?*"
          "*://store.steampowered.com/account/licenses/"
          "*://store.steampowered.com/account/licenses/?*"
          "*://*.steampowered.com/account/registerkey"
          "*://*.steampowered.com/account/registerkey?*"
          "*://*.steampowered.com/account/registerkey/"
          "*://*.steampowered.com/account/registerkey/?*"
          "*://*.steampowered.com/bundle/*"
          "*://*.steampowered.com/sub/*"
          "*://*.steampowered.com/app/*"
          "*://*.steampowered.com/agecheck/*"
          "*://*.steampowered.com/points/*"
          "*://*.steampowered.com/points"
          "*://*.steampowered.com/points?*"
          "*://*.steampowered.com/cart/*"
          "*://*.steampowered.com/cart"
          "*://*.steampowered.com/cart?*"
          "*://steamcommunity.com/sharedfiles"
          "*://steamcommunity.com/sharedfiles?*"
          "*://steamcommunity.com/sharedfiles/"
          "*://steamcommunity.com/sharedfiles/?*"
          "*://steamcommunity.com/workshop"
          "*://steamcommunity.com/workshop?*"
          "*://steamcommunity.com/workshop/"
          "*://steamcommunity.com/workshop/?*"
          "*://steamcommunity.com/sharedfiles/browse"
          "*://steamcommunity.com/sharedfiles/browse?*"
          "*://steamcommunity.com/sharedfiles/browse/"
          "*://steamcommunity.com/sharedfiles/browse/?*"
          "*://steamcommunity.com/workshop/browse"
          "*://steamcommunity.com/workshop/browse?*"
          "*://steamcommunity.com/workshop/browse/"
          "*://steamcommunity.com/workshop/browse/?*"
          "*://steamcommunity.com/id/*/home"
          "*://steamcommunity.com/id/*/home?*"
          "*://steamcommunity.com/id/*/home/"
          "*://steamcommunity.com/id/*/home/?*"
          "*://steamcommunity.com/profiles/*/home"
          "*://steamcommunity.com/profiles/*/home?*"
          "*://steamcommunity.com/profiles/*/home/"
          "*://steamcommunity.com/profiles/*/home/?*"
          "*://steamcommunity.com/id/*/myactivity"
          "*://steamcommunity.com/id/*/myactivity?*"
          "*://steamcommunity.com/id/*/myactivity/"
          "*://steamcommunity.com/id/*/myactivity/?*"
          "*://steamcommunity.com/profiles/*/myactivity"
          "*://steamcommunity.com/profiles/*/myactivity?*"
          "*://steamcommunity.com/profiles/*/myactivity/"
          "*://steamcommunity.com/profiles/*/myactivity/?*"
          "*://steamcommunity.com/id/*/friendactivitydetail/*"
          "*://steamcommunity.com/profiles/*/friendactivitydetail/*"
          "*://steamcommunity.com/id/*/status/*"
          "*://steamcommunity.com/profiles/*/status/*"
          "*://steamcommunity.com/id/*/games"
          "*://steamcommunity.com/id/*/games?*"
          "*://steamcommunity.com/id/*/games/"
          "*://steamcommunity.com/id/*/games/?*"
          "*://steamcommunity.com/profiles/*/games"
          "*://steamcommunity.com/profiles/*/games?*"
          "*://steamcommunity.com/profiles/*/games/"
          "*://steamcommunity.com/profiles/*/games/?*"
          "*://steamcommunity.com/id/*/followedgames"
          "*://steamcommunity.com/id/*/followedgames?*"
          "*://steamcommunity.com/id/*/followedgames/"
          "*://steamcommunity.com/id/*/followedgames/?*"
          "*://steamcommunity.com/profiles/*/followedgames"
          "*://steamcommunity.com/profiles/*/followedgames?*"
          "*://steamcommunity.com/profiles/*/followedgames/"
          "*://steamcommunity.com/profiles/*/followedgames/?*"
          "*://steamcommunity.com/id/*/edit/*"
          "*://steamcommunity.com/profiles/*/edit/*"
          "*://steamcommunity.com/id/*/badges"
          "*://steamcommunity.com/id/*/badges?*"
          "*://steamcommunity.com/id/*/badges/"
          "*://steamcommunity.com/id/*/badges/?*"
          "*://steamcommunity.com/profiles/*/badges"
          "*://steamcommunity.com/profiles/*/badges?*"
          "*://steamcommunity.com/profiles/*/badges/"
          "*://steamcommunity.com/profiles/*/badges/?*"
          "*://steamcommunity.com/id/*/gamecards/*"
          "*://steamcommunity.com/profiles/*/gamecards/*"
          "*://steamcommunity.com/id/*/friendsthatplay/*"
          "*://steamcommunity.com/profiles/*/friendsthatplay/*"
          "*://steamcommunity.com/id/*/friends/*"
          "*://steamcommunity.com/id/*/friends"
          "*://steamcommunity.com/id/*/friends?*"
          "*://steamcommunity.com/profiles/*/friends/*"
          "*://steamcommunity.com/profiles/*/friends"
          "*://steamcommunity.com/profiles/*/friends?*"
          "*://steamcommunity.com/id/*/groups/*"
          "*://steamcommunity.com/id/*/groups"
          "*://steamcommunity.com/id/*/groups?*"
          "*://steamcommunity.com/profiles/*/groups/*"
          "*://steamcommunity.com/profiles/*/groups"
          "*://steamcommunity.com/profiles/*/groups?*"
          "*://steamcommunity.com/id/*/following/*"
          "*://steamcommunity.com/id/*/following"
          "*://steamcommunity.com/id/*/following?*"
          "*://steamcommunity.com/profiles/*/following/*"
          "*://steamcommunity.com/profiles/*/following"
          "*://steamcommunity.com/profiles/*/following?*"
          "*://steamcommunity.com/id/*/inventory"
          "*://steamcommunity.com/id/*/inventory?*"
          "*://steamcommunity.com/id/*/inventory/"
          "*://steamcommunity.com/id/*/inventory/?*"
          "*://steamcommunity.com/profiles/*/inventory"
          "*://steamcommunity.com/profiles/*/inventory?*"
          "*://steamcommunity.com/profiles/*/inventory/"
          "*://steamcommunity.com/profiles/*/inventory/?*"
          "*://steamcommunity.com/market/listings/*"
          "*://steamcommunity.com/market/search/*"
          "*://steamcommunity.com/market/search"
          "*://steamcommunity.com/market/search?*"
          "*://steamcommunity.com/market"
          "*://steamcommunity.com/market?*"
          "*://steamcommunity.com/market/"
          "*://steamcommunity.com/market/?*"
          "*://steamcommunity.com/id/*/stats/*"
          "*://steamcommunity.com/profiles/*/stats/*"
          "*://steamcommunity.com/id/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
          "*://steamcommunity.com/id/*/myworkshopfiles?*browsefilter=mysubscriptions*"
          "*://steamcommunity.com/profiles/*/myworkshopfiles/?*browsefilter=mysubscriptions*"
          "*://steamcommunity.com/profiles/*/myworkshopfiles?*browsefilter=mysubscriptions*"
          "*://steamcommunity.com/id/*/recommended"
          "*://steamcommunity.com/id/*/recommended?*"
          "*://steamcommunity.com/id/*/recommended/"
          "*://steamcommunity.com/id/*/recommended/?*"
          "*://steamcommunity.com/profiles/*/recommended"
          "*://steamcommunity.com/profiles/*/recommended?*"
          "*://steamcommunity.com/profiles/*/recommended/"
          "*://steamcommunity.com/profiles/*/recommended/?*"
          "*://steamcommunity.com/id/*/reviews"
          "*://steamcommunity.com/id/*/reviews?*"
          "*://steamcommunity.com/id/*/reviews/"
          "*://steamcommunity.com/id/*/reviews/?*"
          "*://steamcommunity.com/profiles/*/reviews"
          "*://steamcommunity.com/profiles/*/reviews?*"
          "*://steamcommunity.com/profiles/*/reviews/"
          "*://steamcommunity.com/profiles/*/reviews/?*"
          "*://steamcommunity.com/id/*"
          "*://steamcommunity.com/profiles/*"
          "*://steamcommunity.com/groups/*"
          "*://steamcommunity.com/app/*/guides"
          "*://steamcommunity.com/app/*/guides?*"
          "*://steamcommunity.com/app/*/guides/"
          "*://steamcommunity.com/app/*/guides/?*"
          "*://steamcommunity.com/app/*"
          "*://steamcommunity.com/sharedfiles/filedetails/*"
          "*://steamcommunity.com/sharedfiles/filedetails"
          "*://steamcommunity.com/sharedfiles/filedetails?*"
          "*://steamcommunity.com/workshop/filedetails/*"
          "*://steamcommunity.com/workshop/filedetails"
          "*://steamcommunity.com/workshop/filedetails?*"
          "*://steamcommunity.com/sharedfiles/editguide/?*"
          "*://steamcommunity.com/sharedfiles/editguide?*"
          "*://steamcommunity.com/workshop/editguide/?*"
          "*://steamcommunity.com/workshop/editguide?*"
          "*://steamcommunity.com/tradingcards/boostercreator"
          "*://steamcommunity.com/tradingcards/boostercreator?*"
          "*://steamcommunity.com/tradingcards/boostercreator/"
          "*://steamcommunity.com/tradingcards/boostercreator/?*"
          "*://steamcommunity.com/stats/*/achievements"
          "*://steamcommunity.com/stats/*/achievements?*"
          "*://steamcommunity.com/stats/*/achievements/"
          "*://steamcommunity.com/stats/*/achievements/?*"
          "*://steamcommunity.com/tradeoffer/*"
          ];
        platforms = platforms.all;
        };
      };
    "auto-tab-discard" = buildFirefoxXpiAddon {
      pname = "auto-tab-discard";
      version = "0.6.7";
      addonId = "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4045009/auto_tab_discard-0.6.7.xpi";
      sha256 = "89e59b8603c444258c89a507d7126be52ad7a35e4f7b8cfbca039b746f70b5d5";
      meta = with lib;
      {
        homepage = "https://webextension.org/listing/tab-discard.html";
        description = "Increase browser speed and reduce memory load and when you have numerous open tabs.";
        license = licenses.mpl20;
        mozPermissions = [
          "idle"
          "storage"
          "contextMenus"
          "notifications"
          "alarms"
          "*://*/*"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "behave" = buildFirefoxXpiAddon {
      pname = "behave";
      version = "0.9.7.1";
      addonId = "{17c7f098-dbb8-4f15-ad39-8b578da80f7e}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3606644/behave-0.9.7.1.xpi";
      sha256 = "983b43da26b49df421186c5d550b27aad36e38761089c032eb18441d3ffd21d9";
      meta = with lib;
      {
        description = "A monitoring browser extension for pages acting as bad boys";
        license = licenses.gpl3;
        mozPermissions = [
          "webRequest"
          "webRequestBlocking"
          "notifications"
          "storage"
          "<all_urls>"
          "tabs"
          ];
        platforms = platforms.all;
        };
      };
    "browserpass-ce" = buildFirefoxXpiAddon {
      pname = "browserpass-ce";
      version = "3.8.0";
      addonId = "browserpass@maximbaz.com";
      url = "https://addons.mozilla.org/firefox/downloads/file/4187654/browserpass_ce-3.8.0.xpi";
      sha256 = "5291d94443be41a80919605b0939c16cc62f9100a8b27df713b735856140a9a7";
      meta = with lib;
      {
        homepage = "https://github.com/browserpass/browserpass-extension";
        description = "Browserpass is a browser extension for Firefox and Chrome to retrieve login details from zx2c4's pass (<a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/fcd8dcb23434c51a78197a1c25d3e2277aa1bc764c827b4b4726ec5a5657eb64/http%3A//passwordstore.org\" rel=\"nofollow\">passwordstore.org</a>) straight from your browser. Tags: passwordstore, password store, password manager, passwordmanager, gpg";
        license = licenses.isc;
        mozPermissions = [
          "activeTab"
          "alarms"
          "tabs"
          "clipboardRead"
          "clipboardWrite"
          "nativeMessaging"
          "notifications"
          "webRequest"
          "webRequestBlocking"
          "http://*/*"
          "https://*/*"
          ];
        platforms = platforms.all;
        };
      };
    "buster-captcha-solver" = buildFirefoxXpiAddon {
      pname = "buster-captcha-solver";
      version = "2.0.1";
      addonId = "{e58d3966-3d76-4cd9-8552-1582fbc800c1}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4044701/buster_captcha_solver-2.0.1.xpi";
      sha256 = "9910d2d0add8ba10d7053fd90818e17e6d844050c125f07cb4e4f5759810efcf";
      meta = with lib;
      {
        homepage = "https://github.com/dessant/buster#readme";
        description = "Save time by asking Buster to solve captchas for you.";
        license = licenses.gpl3;
        mozPermissions = [
          "storage"
          "notifications"
          "webRequest"
          "webRequestBlocking"
          "webNavigation"
          "nativeMessaging"
          "<all_urls>"
          "https://google.com/recaptcha/api2/bframe*"
          "https://www.google.com/recaptcha/api2/bframe*"
          "https://google.com/recaptcha/enterprise/bframe*"
          "https://www.google.com/recaptcha/enterprise/bframe*"
          "https://recaptcha.net/recaptcha/api2/bframe*"
          "https://www.recaptcha.net/recaptcha/api2/bframe*"
          "https://recaptcha.net/recaptcha/enterprise/bframe*"
          "https://www.recaptcha.net/recaptcha/enterprise/bframe*"
          "http://127.0.0.1/buster/setup?session=*"
          ];
        platforms = platforms.all;
        };
      };
    "change-timezone-time-shift" = buildFirefoxXpiAddon {
      pname = "change-timezone-time-shift";
      version = "0.1.5";
      addonId = "{acf99872-d701-4863-adc2-cdda1163aa34}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3564562/change_timezone_time_shift-0.1.5.xpi";
      sha256 = "f7806e839b84269af912eb9e821ec6d2cf71866456147d50ee722e93ba89e361";
      meta = with lib;
      {
        homepage = "https://mybrowseraddon.com/change-timezone.html";
        description = "Easily change your timezone to a desired value and protect your privacy.";
        license = licenses.mpl20;
        mozPermissions = [ "*://*/*" "storage" "contextMenus" "webNavigation" ];
        platforms = platforms.all;
        };
      };
    "consent-o-matic" = buildFirefoxXpiAddon {
      pname = "consent-o-matic";
      version = "1.0.12";
      addonId = "gdpr@cavi.au.dk";
      url = "https://addons.mozilla.org/firefox/downloads/file/4074847/consent_o_matic-1.0.12.xpi";
      sha256 = "013ea48757b8a4d84a2a0d944bc49b5612d62bae1d337f9569f425f2b8310e0f";
      meta = with lib;
      {
        homepage = "https://consentomatic.au.dk/";
        description = "Automatic handling of GDPR consent forms";
        license = licenses.mit;
        mozPermissions = [ "activeTab" "storage" "<all_urls>" ];
        platforms = platforms.all;
        };
      };
    "detect-cloudflare-plus" = buildFirefoxXpiAddon {
      pname = "detect-cloudflare-plus";
      version = "1.7.1";
      addonId = "Detect-Cloudflare-PA@cm.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/1114003/detect_cloudflare_plus-1.7.1.xpi";
      sha256 = "57efb43a35b7176d36a387099ebb84bae9cbe0f5bbf2a616a4ae9d3bd87e9b13";
      meta = with lib;
      {
        homepage = "https://github.com/claustromaniac/detect-cloudflare-plus";
        description = "Easily find out which content delivery networks are serving you content on behalf of web servers.";
        license = licenses.gpl3;
        mozPermissions = [ "<all_urls>" "storage" "tabs" "webRequest" ];
        platforms = platforms.all;
        };
      };
    "epubreader" = buildFirefoxXpiAddon {
      pname = "epubreader";
      version = "2.0.13";
      addonId = "{5384767E-00D9-40E9-B72F-9CC39D655D6F}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3594370/epubreader-2.0.13.xpi";
      sha256 = "2a294660517194c37b3f6c89aec4610646102fd38df65f95194aff80464bc46c";
      meta = with lib;
      {
        homepage = "https://www.epubread.com/";
        description = "Read ePub files right in Firefox. No additional software needed!";
        mozPermissions = [
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "downloads"
          "<all_urls>"
          "storage"
          ];
        platforms = platforms.all;
        };
      };
    "ether-metamask" = buildFirefoxXpiAddon {
      pname = "ether-metamask";
      version = "11.7.2";
      addonId = "webextension@metamask.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4211857/ether_metamask-11.7.2.xpi";
      sha256 = "09cdbc8c55b4042692c9b13f85b84b5304b70cac44f5854d0877a753fb17a6f5";
      meta = with lib;
      {
        description = "Ethereum Browser Extension";
        mozPermissions = [
          "storage"
          "unlimitedStorage"
          "clipboardWrite"
          "http://localhost:8545/"
          "https://*.infura.io/"
          "https://*.codefi.network/"
          "https://chainid.network/chains.json"
          "https://lattice.gridplus.io/*"
          "activeTab"
          "webRequest"
          "*://*.eth/"
          "notifications"
          "file://*/*"
          "http://*/*"
          "https://*/*"
          "*://connect.trezor.io/*/popup.html"
          ];
        platforms = platforms.all;
        };
      };
    "firefox-translations" = buildFirefoxXpiAddon {
      pname = "firefox-translations";
      version = "1.3.4buildid20230720.091143";
      addonId = "firefox-translations-addon@mozilla.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4141509/firefox_translations-1.3.4buildid20230720.091143.xpi";
      sha256 = "d2ad4d71079754aec1fab2a03294a5ab5992bd377c57561cfa331e61b5c440e3";
      meta = with lib;
      {
        homepage = "https://blog.mozilla.org/en/mozilla/local-translation-add-on-project-bergamot/";
        description = "Translate websites in your browser, privately, without using the cloud. The functionality from this extension is now integrated into Firefox.";
        license = licenses.mpl20;
        mozPermissions = [
          "<all_urls>"
          "tabs"
          "webNavigation"
          "storage"
          "mozillaAddons"
          "contextMenus"
          ];
        platforms = platforms.all;
        };
      };
    "flagfox" = buildFirefoxXpiAddon {
      pname = "flagfox";
      version = "6.1.70";
      addonId = "{1018e4d6-728f-4b20-ad56-37578a4de76b}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4215210/flagfox-6.1.70.xpi";
      sha256 = "0a639b3eae2d69382f6415df51a5a6d64d67013e1f5618ea7496ae1fa7fc8ac5";
      meta = with lib;
      {
        homepage = "https://flagfox.wordpress.com/";
        description = "Displays a country flag depicting the location of the current website's server and provides a multitude of tools such as site safety checks, whois, translation, similar sites, validation, URL shortening, and more...";
        mozPermissions = [
          "storage"
          "clipboardRead"
          "clipboardWrite"
          "menus"
          "contextMenus"
          "notifications"
          "tabs"
          "webRequest"
          "dns"
          "cookies"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "foxyproxy-standard" = buildFirefoxXpiAddon {
      pname = "foxyproxy-standard";
      version = "8.8";
      addonId = "foxyproxy@eric.h.jung";
      url = "https://addons.mozilla.org/firefox/downloads/file/4212976/foxyproxy_standard-8.8.xpi";
      sha256 = "b93e4e4ed0469a3bcd75450dda0faca451c3a4e16e3ca096262cab7e73bd3460";
      meta = with lib;
      {
        homepage = "https://getfoxyproxy.org";
        description = "FoxyProxy is an open-source, advanced proxy management tool that completely replaces Firefox's limited proxying capabilities. No paid accounts are necessary; bring your own proxies or buy from any vendor. The original proxy tool, since 2006.";
        license = licenses.gpl2;
        mozPermissions = [
          "downloads"
          "notifications"
          "proxy"
          "storage"
          "tabs"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "image-search-options" = buildFirefoxXpiAddon {
      pname = "image-search-options";
      version = "3.0.12";
      addonId = "{4a313247-8330-4a81-948e-b79936516f78}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3059971/image_search_options-3.0.12.xpi";
      sha256 = "1fbdd8597fc32b1be11302a958ea3ba2b010edcfeb432c299637b2c58c6fd068";
      meta = with lib;
      {
        homepage = "http://saucenao.com/";
        description = "A customizable reverse image search tool that conveniently presents a variety of top image search engines.";
        mozPermissions = [
          "storage"
          "contextMenus"
          "activeTab"
          "tabs"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "imagus" = buildFirefoxXpiAddon {
      pname = "imagus";
      version = "0.9.8.74";
      addonId = "{00000f2a-7cde-4f20-83ed-434fcb420d71}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3547888/imagus-0.9.8.74.xpi";
      sha256 = "2b754aa4fca1c99e86d7cdc6d8395e534efd84c394d5d62a1653f9ed519f384e";
      meta = with lib;
      {
        homepage = "https://tiny.cc/Imagus";
        description = "With a simple mouse-over you can enlarge images and display images/videos from links.";
        mozPermissions = [
          "*://*/*"
          "downloads"
          "history"
          "storage"
          "<all_urls>"
          "https://*/search*"
          "https://duckduckgo.com/*"
          ];
        platforms = platforms.all;
        };
      };
    "languagetool" = buildFirefoxXpiAddon {
      pname = "languagetool";
      version = "8.3.0";
      addonId = "languagetool-webextension@languagetool.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4199245/languagetool-8.3.0.xpi";
      sha256 = "e357424e3df9dde4ba10eb9f8f3719ac4830681570557f4d51db15a462cd7667";
      meta = with lib;
      {
        homepage = "https://languagetool.org";
        description = "With this extension you can check text with the free style and grammar checker LanguageTool. It finds many errors that a simple spell checker cannot detect, like mixing up there/their, a/an, or repeating a word.";
        mozPermissions = [
          "activeTab"
          "storage"
          "contextMenus"
          "alarms"
          "http://*/*"
          "https://*/*"
          "file:///*"
          "*://docs.google.com/document/*"
          "*://languagetool.org/*"
          ];
        platforms = platforms.all;
        };
      };
    "passff" = buildFirefoxXpiAddon {
      pname = "passff";
      version = "1.16";
      addonId = "passff@invicem.pro";
      url = "https://addons.mozilla.org/firefox/downloads/file/4202971/passff-1.16.xpi";
      sha256 = "ac410a2fbdaa3a43ae3f0ec01056bc0b037b4441a9e38d2cc330f186c8fce112";
      meta = with lib;
      {
        homepage = "https://github.com/passff/passff";
        description = "Add-on that allows users of the unix password manager 'pass' (see <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/24f646fb865abe6edf9e3f626db62565bfdc2e7819ab33a5b4c30a9573787988/https%3A//www.passwordstore.org/\" rel=\"nofollow\">https://www.passwordstore.org/</a>) to access their password store from Firefox";
        license = licenses.gpl2;
        mozPermissions = [
          "<all_urls>"
          "tabs"
          "storage"
          "nativeMessaging"
          "clipboardWrite"
          "contextMenus"
          "webRequest"
          "webRequestBlocking"
          ];
        platforms = platforms.all;
        };
      };
    "plantuml-visualizer" = buildFirefoxXpiAddon {
      pname = "plantuml-visualizer";
      version = "2.0.3";
      addonId = "{d324f64b-b423-4c2b-a9b4-d415705c26a9}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4113845/plantuml_visualizer-2.0.3.xpi";
      sha256 = "1fd2de969bc185e1c6a7fc26b111f18e5b13690de87486d1f17bb15712752ac7";
      meta = with lib;
      {
        homepage = "https://github.com/WillBooster/plantuml-visualizer";
        description = "A Chrome / Firefox extension for visualizing PlantUML descriptions.";
        mozPermissions = [ "https://*/*" "http://*/*" "storage" "file:///*/*" ];
        platforms = platforms.all;
        };
      };
    "search_by_image" = buildFirefoxXpiAddon {
      pname = "search_by_image";
      version = "6.1.1";
      addonId = "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4209928/search_by_image-6.1.1.xpi";
      sha256 = "254d78084e332190a2b6ccb1959a42257bdc287addc0685419fcde7df1a52e76";
      meta = with lib;
      {
        homepage = "https://github.com/dessant/search-by-image#readme";
        description = "A powerful reverse image search tool, with support for various search engines, such as Google, Bing, Yandex, Baidu and TinEye.";
        license = licenses.gpl3;
        mozPermissions = [
          "alarms"
          "contextMenus"
          "storage"
          "unlimitedStorage"
          "tabs"
          "activeTab"
          "notifications"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
          "http://*/*"
          "https://*/*"
          "file:///*"
          ];
        platforms = platforms.all;
        };
      };
    "sidebery" = buildFirefoxXpiAddon {
      pname = "sidebery";
      version = "5.0.0";
      addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi";
      sha256 = "f592427a1c68d3e51aee208d05588f39702496957771fd84b76a93e364138bf5";
      meta = with lib;
      {
        homepage = "https://github.com/mbnuqw/sidebery";
        description = "Tabs tree and bookmarks in sidebar with advanced containers configuration.";
        license = licenses.mit;
        mozPermissions = [
          "activeTab"
          "tabs"
          "contextualIdentities"
          "cookies"
          "storage"
          "unlimitedStorage"
          "sessions"
          "menus"
          "menus.overrideContext"
          "search"
          "theme"
          ];
        platforms = platforms.all;
        };
      };
    "simple-translate" = buildFirefoxXpiAddon {
      pname = "simple-translate";
      version = "2.8.2";
      addonId = "simple-translate@sienori";
      url = "https://addons.mozilla.org/firefox/downloads/file/4165189/simple_translate-2.8.2.xpi";
      sha256 = "8e8c3af0ffadfd3ff9928355e7be2292befe6c4f0e483f7c37c2d9a34a54f345";
      meta = with lib;
      {
        homepage = "https://simple-translate.sienori.com";
        description = "Quickly translate selected or typed text on web pages. Supports Google Translate and DeepL API.";
        license = licenses.mpl20;
        mozPermissions = [
          "<all_urls>"
          "storage"
          "contextMenus"
          "http://*/*"
          "https://*/*"
          ];
        platforms = platforms.all;
        };
      };
    "skip-redirect" = buildFirefoxXpiAddon {
      pname = "skip-redirect";
      version = "2.3.6";
      addonId = "skipredirect@sblask";
      url = "https://addons.mozilla.org/firefox/downloads/file/3920533/skip_redirect-2.3.6.xpi";
      sha256 = "dbe8950245c1f475c5c1c6daab89c79b83ba4680621c91e80f15be7b09b618ae";
      meta = with lib;
      {
        description = "Some web pages use intermediary pages before redirecting to a final page. This add-on tries to extract the final url from the intermediary url and goes there straight away if successful.";
        license = licenses.mit;
        mozPermissions = [
          "<all_urls>"
          "clipboardWrite"
          "contextMenus"
          "notifications"
          "storage"
          "webRequest"
          "webRequestBlocking"
          ];
        platforms = platforms.all;
        };
      };
    "smart-referer" = buildFirefoxXpiAddon {
      pname = "smart-referer";
      version = "0.2.15";
      addonId = "smart-referer@meh.paranoid.pk";
      url = "https://addons.mozilla.org/firefox/downloads/file/3470999/smart_referer-0.2.15.xpi";
      sha256 = "4751ab905c4d9d13b1f21c9fc179efed7d248e3476effb5b393268b46855bf1a";
      meta = with lib;
      {
        homepage = "https://gitlab.com/smart-referer/smart-referer";
        description = "Improve your privacy by limiting Referer information leak!";
        mozPermissions = [
          "menus"
          "storage"
          "theme"
          "webRequest"
          "webRequestBlocking"
          "*://*/*"
          ];
        platforms = platforms.all;
        };
      };
    "solflare-wallet" = buildFirefoxXpiAddon {
      pname = "solflare-wallet";
      version = "1.60.0";
      addonId = "{6d72262a-b243-4dc6-8f4f-be96c74e0a86}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4212377/solflare_wallet-1.60.0.xpi";
      sha256 = "8857bfe488dfe2347388d5e408afe03f46d7907684bd795ede6c078e438e809a";
      meta = with lib;
      {
        homepage = "https://solflare.com/";
        description = "The only wallet you need to do everything on the Solana blockchain. Store, stake, and swap your tokens with Solflare.";
        mozPermissions = [
          "activeTab"
          "tabs"
          "alarms"
          "*://ftx.com/*"
          "*://ftx.us/*"
          "<all_urls>"
          ];
        platforms = platforms.all;
        };
      };
    "tabliss" = buildFirefoxXpiAddon {
      pname = "tabliss";
      version = "2.6.0";
      addonId = "extension@tabliss.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/3940751/tabliss-2.6.0.xpi";
      sha256 = "de766810f234b1c13ffdb7047ae6cbf06ed79c3d08b51a07e4766fadff089c0f";
      meta = with lib;
      {
        homepage = "https://tabliss.io";
        description = "A beautiful New Tab page with many customisable backgrounds and widgets that does not require any permissions.";
        license = licenses.gpl3;
        mozPermissions = [ "storage" ];
        platforms = platforms.all;
        };
      };
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.9.19";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/4197314/tree_style_tab-3.9.19.xpi";
      sha256 = "bb67f47a554f8f937f4176bee6144945eb0f240630b93f73d2cff49f0985b55a";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        mozPermissions = [
          "activeTab"
          "contextualIdentities"
          "cookies"
          "menus"
          "menus.overrideContext"
          "notifications"
          "search"
          "sessions"
          "storage"
          "tabs"
          "theme"
          ];
        platforms = platforms.all;
        };
      };
    "ublock-origin" = buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.55.0";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4216633/ublock_origin-1.55.0.xpi";
      sha256 = "a02ca1d32737c3437f97553e5caaead6479a66ac1f8ff3b84a06cfa6bb0c7647";
      meta = with lib;
      {
        homepage = "https://github.com/gorhill/uBlock#ublock-origin";
        description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
        license = licenses.gpl3;
        mozPermissions = [
          "alarms"
          "dns"
          "menus"
          "privacy"
          "storage"
          "tabs"
          "unlimitedStorage"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
          "http://*/*"
          "https://*/*"
          "file://*/*"
          "https://easylist.to/*"
          "https://*.fanboy.co.nz/*"
          "https://filterlists.com/*"
          "https://forums.lanik.us/*"
          "https://github.com/*"
          "https://*.github.io/*"
          "https://*.letsblock.it/*"
          "https://github.com/uBlockOrigin/*"
          "https://ublockorigin.github.io/*"
          "https://*.reddit.com/r/uBlockOrigin/*"
          ];
        platforms = platforms.all;
        };
      };
    "user-agent-string-switcher" = buildFirefoxXpiAddon {
      pname = "user-agent-string-switcher";
      version = "0.5.0";
      addonId = "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4098688/user_agent_string_switcher-0.5.0.xpi";
      sha256 = "9dc8da3c8c46d4f04d12fd789c63501fa6a2f502f859b286939a090db63eae33";
      meta = with lib;
      {
        homepage = "http://add0n.com/useragent-switcher.html";
        description = "Spoof websites trying to gather information about your web navigation—like your browser type and operating system—to deliver distinct content you may not want.";
        license = licenses.mpl20;
        mozPermissions = [
          "storage"
          "<all_urls>"
          "webNavigation"
          "webRequest"
          "webRequestBlocking"
          "contextMenus"
          "*://*/*"
          ];
        platforms = platforms.all;
        };
      };
    "view-page-archive" = buildFirefoxXpiAddon {
      pname = "view-page-archive";
      version = "5.0.0";
      addonId = "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4191232/view_page_archive-5.0.0.xpi";
      sha256 = "73df57b7ffe9d3c851518bc29831b82e5c3862a41782923649bdb20a2223ea7f";
      meta = with lib;
      {
        homepage = "https://github.com/dessant/web-archives#readme";
        description = "View archived and cached versions of web pages on 10+ search engines, such as the Wayback Machine, Archive․is, Google, Bing and Yandex";
        license = licenses.gpl3;
        mozPermissions = [
          "alarms"
          "contextMenus"
          "storage"
          "unlimitedStorage"
          "tabs"
          "activeTab"
          "notifications"
          "webRequest"
          "webRequestBlocking"
          "<all_urls>"
          "http://*/*"
          "https://*/*"
          "file:///*"
          ];
        platforms = platforms.all;
        };
      };
    "window-titler" = buildFirefoxXpiAddon {
      pname = "window-titler";
      version = "3.0";
      addonId = "{35dd5f9a-ca89-4643-b107-f07d09cc94b5}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3365362/window_titler-3.0.xpi";
      sha256 = "9b1be1ce4fdcc25504a6c269f1e686f689bef599b7dcacc9b06b893c8ea11ca6";
      meta = with lib;
      {
        homepage = "https://github.com/tpamula/webextension-window-titler";
        description = "Label your windows and profiles using custom window titles.";
        license = licenses.mit;
        mozPermissions = [ "sessions" "storage" ];
        platforms = platforms.all;
        };
      };
    "youtube-addon" = buildFirefoxXpiAddon {
      pname = "youtube-addon";
      version = "4.600";
      addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4219118/youtube_addon-4.600.xpi";
      sha256 = "23d76f6d2e6dd8f2e22a6ecfc20a77ea8cb9125c107bdb352657607cf0bbfad6";
      meta = with lib;
      {
        homepage = "https://github.com/code4charity/YouTube-Extension/";
        description = "Youtube Extension. Powerful but lightweight. Enrich your Youtube &amp; content selection.\nMake YouTube tidy&amp;smart! Layout Filters Shortcuts Adblocker Playlist";
        mozPermissions = [
          "contextMenus"
          "storage"
          "https://www.youtube.com/*"
          ];
        platforms = platforms.all;
        };
      };
    }