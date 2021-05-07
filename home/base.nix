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
