{ pkgs, ... }: {
  programs.yazi = {
    enable = true;
    settings = {};
  };
  # recomended packages
  # https://yazi-rs.github.io/docs/installation
  home.packages = with pkgs; [
    ffmpeg
    _7zz
    jq
    poppler
    fd
    ripgrep
    zoxide
    imagemagick
    wl-clipboard
  ];
}
