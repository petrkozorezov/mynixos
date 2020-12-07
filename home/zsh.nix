{pkgs, ...}:
{
  enable  = true;
  dotDir  = ".config/zsh"; # FIXME remove hardcode
  #WLR_DRM_DEVICES=`readlink -f /dev/dri/by-path/pci-0000:09:00.0-card`:`readlink -f /dev/dri/by-path/pci-0000:00:02.0-card` \
  initExtra =
    ''
      path+="$HOME/bin"
      # pure
      autoload -U promptinit; promptinit
      PURE_GIT_PULL=0
      prompt pure
      # TODO move to more appropriate place
      test -z $DISPLAY && \
      test 1 -eq $XDG_VTNR && \
      WLR_DRM_DEVICES=`readlink -f /dev/dri/by-path/pci-0000:2f:00.0-card` \
        sway -V 2> sway.log && \
      exit;
    '';
  oh-my-zsh =
    {
      enable  = true;
      plugins = [ "git" "fasd" "sudo" "docker" "python" ];
    };
  plugins =
    [
      # TODO autoenv
      {
        name = "pure";
        src = pkgs.fetchFromGitHub
          {
            owner  = "sindresorhus";
            repo   = "pure";
            rev    = "0a92b02dd4172f6c64fdc9b81fe6cd4bddb0a23b"; #
            sha256 = "0l8jqhmmjn7p32hdjnv121xsjnqd2c0plhzgydv2yzrmqgyvx7cc";
          };
      }
      { # TODO understand how to use it
        name = "zsh-nix-shell";
        src  = pkgs.fetchFromGitHub
          {
            owner  = "chisui";
            repo   = "zsh-nix-shell";
            rev    = "a65382a353eaee5a98f068c330947c032a1263bb";
            sha256 = "0l41ac5b7p8yyjvpfp438kw7zl9dblrpd7icjg1v3ig3xy87zv0n";
          };
      }
    ];
}
