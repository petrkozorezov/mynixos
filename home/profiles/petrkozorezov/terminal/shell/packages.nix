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
    srisum # hash sum in sri format

    # hardware
    pciutils
    usbutils

    # admin
    bind.dnsutils
    ldns
    lsof

    # pmount # (?)
    lm_sensors

    sshfs
  ];
}
