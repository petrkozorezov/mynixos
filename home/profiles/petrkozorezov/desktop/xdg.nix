{ pkgs, ... }:
{
  xdg = {
    # https://wiki.archlinux.org/title/Default%20applicationsq
    userDirs = {
      enable            = true;
      createDirectories = true;
    };
    desktopEntries = {
       # firefox = {
       #   name        = "Firefox";
       #   genericName = "Web Browser";
       #   exec        = "firefox %U";
       #   terminal    = false;
       #   categories  = [ "Application" "Network" "WebBrowser" ];
       #   mimeType    = [ "text/html" "text/xml" ];
       # };
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications             = {
        # TODO move to specific places
        "x-scheme-handler/http"         = "firefox.desktop";
        "x-scheme-handler/https"        = "firefox.desktop";
        "x-scheme-handler/ftp"          = "firefox.desktop";
        "x-scheme-handler/chrome"       = "firefox.desktop";
        "text/html"                     = "firefox.desktop";
        "application/x-extension-htm"   = "firefox.desktop";
        "application/x-extension-html"  = "firefox.desktop";
        "application/x-extension-shtml" = "firefox.desktop";
        "application/xhtml+xml"         = "firefox.desktop";
        "application/x-extension-xhtml" = "firefox.desktop";
        "application/x-extension-xht"   = "firefox.desktop";

        "image/jpeg"      = "imv-folder.desktop";
        "application/pdf" = "org.pwmt.zathura-pdf-mupdf.desktop";

        "text/plain"                = "sublime_text.desktop";
        "text/tab-separated-values" = "sublime_text.desktop";
        "application/text"          = "sublime_text.desktop";
        "application/octet-stream"  = "sublime_text.desktop";

        "x-scheme-handler/tg"           = "userapp-Telegram Desktop-1FKGD1.desktop"; # FIXME
        "x-scheme-handler/mailto"       = "chromium-browser.desktop"; # FIXME

      };
    };
    # to override changes made by applications
    configFile."mimeapps.list".force = true;
  };

  home.packages = with pkgs; [ xdg-utils mimeo ];
}
