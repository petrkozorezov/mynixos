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
      discord

      # books
      # calibre

      # office
      libreoffice

      # multimedia
      mellowplayer
      playerctl
      mpv
      imv
      nomacs

      # others
      # gucharmap
    ];
}
