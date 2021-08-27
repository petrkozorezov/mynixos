{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # utils
    bc
    killall
    glances
    bandwhich
    procs
    curl wget
    ranger mc
    # nnn
    jq
    gnupg
    unzip
    vim
    neofetch
    # rlwrap
    # asciinema
    # ripgrep
    # ruplacer
    pandoc
    qrencode

    # hardware
    pciutils
    usbutils

    # admin
    bind.dnsutils
    ldns
    lsof

    # pmount # (?)
    lm_sensors
    nix-index

    # sound
    pulsemixer pamixer

    # obsidian
    # zotero
  ];
}
