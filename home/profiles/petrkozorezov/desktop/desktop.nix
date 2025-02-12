{ pkgs, ... }: {
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
      defaultApplications = {
        # to test: `xdg-mime query default image/png`
        # desktop files in
        #  - /run/current-system/sw/share/applications/
        #  - ~/.nix-profile/share/applications/
        "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
        # "x-scheme-handler/mailto"       = "chromium-browser.desktop"; # TODO thunderbird
        "image/png"       = "imv.desktop";
        "image/jpeg"      = "imv.desktop";
        "image/gif"       = "imv.desktop";
        "image/webp"      = "imv.desktop";
        "image/svg+xml"   = "imv.desktop";
        "image/tiff"      = "imv.desktop";
        "image/bmp"       = "imv.desktop";

        "video/mp4"        = "mpv.desktop";
        "video/x-matroska" = "mpv.desktop";
        "video/webm"       = "mpv.desktop";
        "video/ogg"        = "mpv.desktop";
        "video/x-msvideo"  = "mpv.desktop"; # AVI
        "video/x-flv"      = "mpv.desktop";
        "video/quicktime"  = "mpv.desktop"; # MOV
        "video/mpeg"       = "mpv.desktop";

        "audio/mpeg" = "mpv.desktop";
        "audio/ogg"  = "mpv.desktop";
        "audio/wav"  = "mpv.desktop";
        "audio/flac" = "mpv.desktop";
        "audio/aac"  = "mpv.desktop";

        ## TODO archives
        # "application/zip"              = "file-roller.desktop";
        # "application/x-tar"            = "file-roller.desktop";
        # "application/x-7z-compressed"  = "file-roller.desktop";
        # "application/x-rar-compressed" = "file-roller.desktop";

        ## TODO books
      };
    };
    # to override changes made by applications
    configFile."mimeapps.list".force = true;
  };

  home.packages = with pkgs; [
    # privacy
    veracrypt
    # opensnitch
    # opensnitch-ui

    # mail clients
    # TODO

    # messengers
    tdesktop
    slack

    # books
    calibre

    # office
    libreoffice

    # multimedia
    playerctl
    mpv
    imv
    nomacs
    spotify

    # others
    # gucharmap
    # uhk-agent

    # sound
    pulsemixer pamixer

    # obsidian
    # zotero

    xdg-utils
    mimeo
  ];







  gtk = {
    enable = true;
    font = {
      name = "Hack 10";
      package = pkgs.hack-font;
    };

    # themes
    # arc?
    iconTheme = {
      name = "Arc";
      package = pkgs.arc-icon-theme;
      # la-capitaine-icon-theme
    };
    # TODO https://github.com/mitch-kyle/monokai-gtk
    theme = {
      package = pkgs.adw-gtk3;
      name    = "adw-gtk3";
    };
    cursorTheme = {
      name    = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
      size    = 16;
    };

    gtk2.extraConfig = ''
      gtk-application-prefer-dark-theme=1
      '';
    # ''
    #   gtk-cursor-theme-size = 16
    #   gtk-cursor-theme-name = "${capitaine-cursors-white}"
    #   gtk-color-scheme = "base_color: #404552"
    #   gtk-color-scheme = "text_color: #ffffff"
    #   gtk-color-scheme = "bg_color: #383c4a"
    #   gtk-color-scheme = "fg_color: #ffffff"
    #   gtk-color-scheme = "tooltip_bg_color: #4B5162"
    #   gtk-color-scheme = "tooltip_fg_color: #ffffff"
    #   gtk-color-scheme = "selected_bg_color: #5294e2"
    #   gtk-color-scheme = "selected_fg_color: #ffffff"
    #   gtk-color-scheme = "insensitive_bg_color: #3e4350"
    #   gtk-color-scheme = "insensitive_fg_color: #7c818c"
    #   gtk-color-scheme = "notebook_bg: #404552"
    #   gtk-color-scheme = "dark_sidebar_bg: #353945"
    #   gtk-color-scheme = "link_color: #5294e2"
    #   gtk-color-scheme = "menu_bg: #2e2f29"
    # '';
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
      # gtk-cursor-theme-size = 16;
      # gtk-cursor-theme-name = "${capitaine-cursors-white}";
    };
  };

  # home.sessionVariables.GTK_THEME = "palenight";
}
