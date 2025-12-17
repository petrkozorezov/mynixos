{ pkgs, ... }: {
  home.packages = with pkgs; [
    bandwhich
    btop
    nvtopPackages.full amdgpu_top #gputop

    # utils
    dust    # du
    duf     # df
    procs   # ps
    fd      # find
    ripgrep # grep
    tokei   # cloc
    bat     # cat
    jaq     # jq
    rsync
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
    qrencode
    srisum # hash sum in sri format
    inetutils

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

    # dev
    gtypist
    pandoc

    cachix
    devenv
    gnumake
    rsync

    act # git actions local runner
  ];
}
