{pkgs, ...}:
with pkgs;
[
  fasd

  gtypist
  #ktouch

  # langs
  erlang

  # editors
  vim
  #emacs emacs-all-the-icons-fonts ripgrep coreutils fd
  sublime3

  # tools
  git gitAndTools.hub gitAndTools.gh glow
  gnumake
  killall
  bc
  glances
  curl wget
  ranger
  #neofetch
  #docker-compose
  cloc
  jq
  #qcachegrind
  graphviz
  pulsemixer pamixer
  mtr
  gnupg
  entr
  ripgrep
  ripgrep-all
  pciutils
  unzip

  # TODO unmask
  # dropbox-cli

  veracrypt
  keepassxc
  #keepass-keefox # TODO try it
  #gucharmap

  # browser, mail, ...
  firefox-wayland
  #firefox
  chromium
  #qutebrowser
  # surf
  # thunderbird
  tdesktop
  slack

  # calibre
  libreoffice
  mellowplayer
  playerctl
  mplayer
  kitty # for ranger images preview

  #syncthing
  #geekbench

  #appimage-run

  # hey # FIXME
  # nixops
  grapherl

  #uhk-agent

]
