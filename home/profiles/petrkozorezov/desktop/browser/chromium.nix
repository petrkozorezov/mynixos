{ pkgs, ... }: {
  programs.chromium = {
    enable = true;
    # FIXME ungoogled
    #  - google meet screen sharing
    #  - profile cleanup after restart
    #  - 2FA doesn't work
    package = pkgs.chromium;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock Origin    - https://github.com/gorhill/uBlock
      "gcbommkclmclpchllfjekcdonpmejbdp" # HTTPS Everywhere - https://github.com/EFForg/https-everywhere
      "ibnejdfjmmkpcnlpebklmnkoeoihofec" # TronLink
    ];
  };
}
