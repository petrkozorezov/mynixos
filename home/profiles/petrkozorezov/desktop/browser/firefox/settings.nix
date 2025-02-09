{
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
  "extensions.autoDisableScopes"                        = 0    ; # prevent extension install notification

  # security
  # prevent av/malware injection
  "accessibility.force_disabled" = 1;

  # performance
  # https://www.reddit.com/r/browsers/comments/nugbaw/firefox_going_up_to_1000_mb_with_only_5_tabs_open/
  "dom.ipc.processCount"                       = 0;
  "dom.ipc.processPrelaunch.enabled"           = false;
  "dom.ipc.keepProcessesAlive.privilegedabout" = 0;
}
