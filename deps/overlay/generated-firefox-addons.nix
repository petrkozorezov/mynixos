{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
    "augmented-steam" = buildFirefoxXpiAddon {
      pname = "augmented-steam";
      version = "2.4.1";
      addonId = "{1be309c5-3e4f-4b99-927d-bb500eb4fa88}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4054613/augmented_steam-2.4.1.xpi";
      sha256 = "962412b40471bc0dfafe72cd29c7e80ef789c33dc322086bbc03d3a89a5d08db";
      meta = with lib;
      {
        homepage = "https://augmentedsteam.com/";
        description = "Augments your Steam Experience";
        license = licenses.gpl3;
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
        platforms = platforms.all;
        };
      };
    "ether-metamask" = buildFirefoxXpiAddon {
      pname = "ether-metamask";
      version = "10.28.3";
      addonId = "webextension@metamask.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4096869/ether_metamask-10.28.3.xpi";
      sha256 = "bf034e8296bc4a6aafc5152a240c0c3a40641e1687a95c0ec7f964118a3e3e97";
      meta = with lib;
      {
        description = "Ethereum Browser Extension";
        platforms = platforms.all;
        };
      };
    "flagfox" = buildFirefoxXpiAddon {
      pname = "flagfox";
      version = "6.1.62";
      addonId = "{1018e4d6-728f-4b20-ad56-37578a4de76b}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4104463/flagfox-6.1.62.xpi";
      sha256 = "db564593264aa417ec659c53de5bdda28eec0e52b250b329afb0cff982fed382";
      meta = with lib;
      {
        homepage = "https://flagfox.wordpress.com/";
        description = "Displays a country flag depicting the location of the current website's server and provides a multitude of tools such as site safety checks, whois, translation, similar sites, validation, URL shortening, and more...";
        platforms = platforms.all;
        };
      };
    "foxyproxy-standard" = buildFirefoxXpiAddon {
      pname = "foxyproxy-standard";
      version = "7.5.1";
      addonId = "foxyproxy@eric.h.jung";
      url = "https://addons.mozilla.org/firefox/downloads/file/3616824/foxyproxy_standard-7.5.1.xpi";
      sha256 = "42109bc250e20aafd841183d09c7336008ab49574b5e8aa9206991bb306c3a65";
      meta = with lib;
      {
        homepage = "https://getfoxyproxy.org";
        description = "FoxyProxy is an advanced proxy management tool that completely replaces Firefox's limited proxying capabilities. For a simpler tool and less advanced configuration options, please use FoxyProxy Basic.";
        license = licenses.gpl2;
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
        platforms = platforms.all;
        };
      };
    "languagetool" = buildFirefoxXpiAddon {
      pname = "languagetool";
      version = "6.2.5";
      addonId = "languagetool-webextension@languagetool.org";
      url = "https://addons.mozilla.org/firefox/downloads/file/4086343/languagetool-6.2.5.xpi";
      sha256 = "d17977befe90e9c15b86407668a985587e8fb25aee353c7d47d34b917dec7cd9";
      meta = with lib;
      {
        homepage = "https://languagetool.org";
        description = "With this extension you can check text with the free style and grammar checker LanguageTool. It finds many errors that a simple spell checker cannot detect, like mixing up there/their, a/an, or repeating a word.";
        platforms = platforms.all;
        };
      };
    "passff" = buildFirefoxXpiAddon {
      pname = "passff";
      version = "1.14.1";
      addonId = "passff@invicem.pro";
      url = "https://addons.mozilla.org/firefox/downloads/file/4069548/passff-1.14.1.xpi";
      sha256 = "465c204212b93546d20dc8fef2c99ac8b06b2d884cd2d38aaf73d825c8be7383";
      meta = with lib;
      {
        homepage = "https://github.com/passff/passff";
        description = "Add-on that allows users of the unix password manager 'pass' (see <a href=\"https://prod.outgoing.prod.webservices.mozgcp.net/v1/24f646fb865abe6edf9e3f626db62565bfdc2e7819ab33a5b4c30a9573787988/https%3A//www.passwordstore.org/\" rel=\"nofollow\">https://www.passwordstore.org/</a>) to access their password store from Firefox";
        license = licenses.gpl2;
        platforms = platforms.all;
        };
      };
    "plantuml-visualizer" = buildFirefoxXpiAddon {
      pname = "plantuml-visualizer";
      version = "2.0.1";
      addonId = "{d324f64b-b423-4c2b-a9b4-d415705c26a9}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4079147/plantuml_visualizer-2.0.1.xpi";
      sha256 = "71c72f3796023ae44a5a54f952aabe6efe20da09064ef2b66d147cd9ba3c3129";
      meta = with lib;
      {
        homepage = "https://github.com/WillBooster/plantuml-visualizer";
        description = "A Chrome / Firefox extension for visualizing PlantUML descriptions.";
        platforms = platforms.all;
        };
      };
    "search_by_image" = buildFirefoxXpiAddon {
      pname = "search_by_image";
      version = "5.4.2";
      addonId = "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4034617/search_by_image-5.4.2.xpi";
      sha256 = "327549ce86f8dc27794ece4a065cf673e007eefe716fb188b8c6d28102fca22f";
      meta = with lib;
      {
        homepage = "https://github.com/dessant/search-by-image#readme";
        description = "A powerful reverse image search tool, with support for various search engines, such as Google, Bing, Yandex, Baidu and TinEye.";
        license = licenses.gpl3;
        platforms = platforms.all;
        };
      };
    "sidebery" = buildFirefoxXpiAddon {
      pname = "sidebery";
      version = "4.10.2";
      addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
      url = "https://addons.mozilla.org/firefox/downloads/file/3994928/sidebery-4.10.2.xpi";
      sha256 = "60e35f2bfac88e5b2b4e044722dde49b4ed0eca9e9216f3d67dafdd9948273ac";
      meta = with lib;
      {
        homepage = "https://github.com/mbnuqw/sidebery";
        description = "Tabs tree and bookmarks in sidebar with advanced containers configuration.";
        license = licenses.mit;
        platforms = platforms.all;
        };
      };
    "simple-translate" = buildFirefoxXpiAddon {
      pname = "simple-translate";
      version = "2.8.1";
      addonId = "simple-translate@sienori";
      url = "https://addons.mozilla.org/firefox/downloads/file/4072586/simple_translate-2.8.1.xpi";
      sha256 = "23f1953d588d5d9943ab43845407b84a51bbcc1824b8c010ed56caa119711a27";
      meta = with lib;
      {
        homepage = "https://simple-translate.sienori.com";
        description = "Quickly translate selected or typed text on web pages. Supports Google Translate and DeepL API.";
        license = licenses.mpl20;
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
        platforms = platforms.all;
        };
      };
    "solflare-wallet" = buildFirefoxXpiAddon {
      pname = "solflare-wallet";
      version = "1.43.2";
      addonId = "{6d72262a-b243-4dc6-8f4f-be96c74e0a86}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4096959/solflare_wallet-1.43.2.xpi";
      sha256 = "05430da68db79a31389a3dbb7cd5b03c3e795a5961285830c3a9f858ae2980a1";
      meta = with lib;
      {
        homepage = "https://solflare.com/";
        description = "The only wallet you need to do everything on the Solana blockchain. Store, stake, and swap your tokens with Solflare.";
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
        platforms = platforms.all;
        };
      };
    "tree-style-tab" = buildFirefoxXpiAddon {
      pname = "tree-style-tab";
      version = "3.9.15";
      addonId = "treestyletab@piro.sakura.ne.jp";
      url = "https://addons.mozilla.org/firefox/downloads/file/4088468/tree_style_tab-3.9.15.xpi";
      sha256 = "7c993bae2d43488615f1a3b7459a2c35730a486b3855049709c636a84751d252";
      meta = with lib;
      {
        homepage = "http://piro.sakura.ne.jp/xul/_treestyletab.html.en";
        description = "Show tabs like a tree.";
        platforms = platforms.all;
        };
      };
    "ublock-origin" = buildFirefoxXpiAddon {
      pname = "ublock-origin";
      version = "1.49.2";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4103048/ublock_origin-1.49.2.xpi";
      sha256 = "39266486f720cd31d291d2fdad78625b079782a05517e1936eec7e780bc2a84d";
      meta = with lib;
      {
        homepage = "https://github.com/gorhill/uBlock#ublock-origin";
        description = "Finally, an efficient wide-spectrum content blocker. Easy on CPU and memory.";
        license = licenses.gpl3;
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
        platforms = platforms.all;
        };
      };
    "view-page-archive" = buildFirefoxXpiAddon {
      pname = "view-page-archive";
      version = "4.0.0";
      addonId = "{d07ccf11-c0cd-4938-a265-2a4d6ad01189}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4065318/view_page_archive-4.0.0.xpi";
      sha256 = "3e0e0a7d757135975e093e2339f750ce8a762be47c802c59679a0994931ed346";
      meta = with lib;
      {
        homepage = "https://github.com/dessant/web-archives#readme";
        description = "View archived and cached versions of web pages on 10+ search engines, such as the Wayback Machine, Archive․is, Google, Bing and Yandex";
        license = licenses.gpl3;
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
        platforms = platforms.all;
        };
      };
    "youtube-addon" = buildFirefoxXpiAddon {
      pname = "youtube-addon";
      version = "4.9";
      addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4104259/youtube_addon-4.9.xpi";
      sha256 = "89e9915310101c62c1ef1c67be9963a5dcb3ea90778836f59f4dfc16b95d2cf4";
      meta = with lib;
      {
        homepage = "https://github.com/code4charity/YouTube-Extension/";
        description = "Youtube Extension. Powerful but lightweight. Enrich your Youtube &amp; content selection.\nMake YouTube tidy&amp;smart! Layout Filters Shortcuts Adblocker Playlist";
        platforms = platforms.all;
        };
      };
    }