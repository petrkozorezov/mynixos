{ config, pkgs, deps, ... }: {
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
        "x-scheme-handler/tg"           = "org.telegram.desktop.desktop";
        "application/x-xdg-protocol-tg" = "org.telegram.desktop.desktop";

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

    # old version for TrueCript disk format support
    # (veracrypt.overrideAttrs (_: prev: rec {
    #   pname = "veracrypt";
    #   version = "1.25.9";
    #   dontPatch = true;
    #   src = fetchurl {
    #     url = "https://launchpad.net/${pname}/trunk/${lib.toLower version}/+download/VeraCrypt_${version}_Source.tar.bz2";
    #     sha256 = "sha256-drbhgYS8IaQdKUn/Y9ch1JBUpxbO/zpL13tcNRC3lK8=";
    #   };
    # }))

    # opensnitch
    # opensnitch-ui

    # mail clients
    # TODO

    zed-editor

    # messengers
    telegram-desktop
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

    networkmanager-vpnc
    networkmanager-l2tp
    networkmanagerapplet
    pavucontrol

    # photos
    rawtherapee
    digikam

    # filemanager
    # TODO services.gvfs.enable = true;
    pcmanfm
  ];

  home.sessionVariables = {
    SDL_VIDEODRIVER = "wayland";
    ENABLE_VULKAN   = "true";
    NIXOS_OZONE_WL  = "1";
    CALIBRE_USE_SYSTEM_THEME="true"; # calibre сознательно игнорирует системную цветовую схему :-\
  };
}
