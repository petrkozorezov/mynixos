{ pkgs, ... }:
{

  home.packages = with pkgs;
    [
      # privacy
      veracrypt
      # opensnitch
      # opensnitch-ui

      # mail clients
      # TODO

      # messengers
      tdesktop
      slack
      #discord

      # books
      calibre

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
      uhk-agent
    ];
}
