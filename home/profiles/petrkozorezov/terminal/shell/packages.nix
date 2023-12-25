{ pkgs, ... }: {
  home.packages =
  with pkgs; [
    bandwhich
    btop
    radeontop #gputop

    # utils
    jq
    bc
    file
    killall
    curl wget
    mc
    # nnn
    gnupg
    unzip
    vim
    # rlwrap
    # asciinema
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

    sshfs
  ];
}
