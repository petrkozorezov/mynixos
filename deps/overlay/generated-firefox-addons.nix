{ buildFirefoxXpiAddon, fetchurl, lib, stdenv }:
  {
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
    "ether-metamask" = buildFirefoxXpiAddon {
      pname = "ether-metamask";
      version = "10.27.0";
      addonId = "webextension@metamask.io";
      url = "https://addons.mozilla.org/firefox/downloads/file/4090626/ether_metamask-10.27.0.xpi";
      sha256 = "9d1fb78615e6fc036aa2edade6441c091b5541ce85182c991a7677d45deaac61";
      meta = with lib;
      {
        description = "Ethereum Browser Extension";
        platforms = platforms.all;
        };
      };
    "flagfox" = buildFirefoxXpiAddon {
      pname = "flagfox";
      version = "6.1.61";
      addonId = "{1018e4d6-728f-4b20-ad56-37578a4de76b}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4091245/flagfox-6.1.61.xpi";
      sha256 = "e2e243e82b971b02e20ede3ce1c514f9955a4392b11c0c70cb4d4cf2750e48e6";
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
      version = "1.43.1";
      addonId = "{6d72262a-b243-4dc6-8f4f-be96c74e0a86}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4091629/solflare_wallet-1.43.1.xpi";
      sha256 = "054fc09d0f596ab66a850915392f0aa81bf56db17fad8caac3b4f724af7b9bf0";
      meta = with lib;
      {
        homepage = "https://solflare.com/";
        description = "The only wallet you need to do everything on the Solana blockchain. Store, stake, and swap your tokens with Solflare.";
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
      version = "1.48.4";
      addonId = "uBlock0@raymondhill.net";
      url = "https://addons.mozilla.org/firefox/downloads/file/4092158/ublock_origin-1.48.4.xpi";
      sha256 = "d7666b963c2969b0014937aae55472eea5098ff21ed3bea8a2e1f595f62856c1";
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
      version = "0.4.9";
      addonId = "{a6c4a591-f1b2-4f03-b3ff-767e5bedf4e7}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4047133/user_agent_string_switcher-0.4.9.xpi";
      sha256 = "617ab726419f6c1addedc727ad41dca18f52fbde34af59ed7d42425f139129d1";
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
      version = "4.6";
      addonId = "{3c6bf0cc-3ae2-42fb-9993-0d33104fdcaf}";
      url = "https://addons.mozilla.org/firefox/downloads/file/4089432/youtube_addon-4.6.xpi";
      sha256 = "37a92848d64cf997363b7741a0f0b4efe222d34f0f19f0757d3d917ffac9a6aa";
      meta = with lib;
      {
        homepage = "https://github.com/code4charity/YouTube-Extension/";
        description = "Youtube Extension. Powerful but lightweight. Enrich your Youtube &amp; content selection.\nMake YouTube tidy&amp;smart! Layout Filters Shortcuts Adblocker Playlist";
        platforms = platforms.all;
        };
      };
    }