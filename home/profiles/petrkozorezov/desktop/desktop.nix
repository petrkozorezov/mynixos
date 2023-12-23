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
      # slack
      # discord

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

    ];
}
