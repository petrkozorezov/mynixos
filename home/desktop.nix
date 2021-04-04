{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      # secrets
      veracrypt

      # browsers
      firefox-wayland
      chromium

      # mail clients
      thunderbird

      # messengers
      tdesktop
      slack

      # books
      # calibre

      # office
      libreoffice

      # multimedia
      #mellowplayer
      playerctl
      mpv
      nomacs

      # others
      # gucharmap
    ];
}
