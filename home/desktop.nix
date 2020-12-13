{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      # secrets
      veracrypt
      keepassxc
      #keepass-keefox # TODO try it

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
      mellowplayer
      playerctl
      mplayer

      # others
      # gucharmap
    ];
}
