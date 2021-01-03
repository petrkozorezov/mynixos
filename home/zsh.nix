{ pkgs, ... }:
{
  programs = {
    zsh = {
      enable  = true;
      dotDir  = ".config/zsh"; # FIXME remove hardcode
      #WLR_DRM_DEVICES=`readlink -f /dev/dri/by-path/pci-0000:09:00.0-card`:`readlink -f /dev/dri/by-path/pci-0000:00:02.0-card` \
      initExtra =
        ''
          # pure
          autoload -U promptinit; promptinit
          PURE_GIT_PULL=0
          prompt pure

          path+="$HOME/bin"
          # TODO move it to a more appropriate place
          test -z $DISPLAY && \
          test 1 -eq $XDG_VTNR && \
          WLR_DRM_DEVICES=`readlink -f /dev/dri/by-path/pci-0000:2f:00.0-card` \
            sway -V 2> sway.log && \
          exit;
        '';
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        extended              = true;
      };
      enableCompletion = true;
      shellAliases = {
        ".."  = "cd ..";
        "..."  = "cd ../..";
        "cat" = "bat";
      };
      oh-my-zsh =
        {
          enable  = true;
          plugins = [ "git" "fasd" "sudo" ];
        };
      plugins =
        [
          # fast simple prompt
          {
            name = "pure";
            src = pkgs.fetchFromGitHub
              {
                owner  = "sindresorhus";
                repo   = "pure";
                rev    = "0a92b02dd4172f6c64fdc9b81fe6cd4bddb0a23b";
                sha256 = "0l8jqhmmjn7p32hdjnv121xsjnqd2c0plhzgydv2yzrmqgyvx7cc";
              };
          }

          # fzf-fasd integration
          {
            name = "fzf-fasd";
            src = pkgs.fetchFromGitHub
              {
                owner  = "wookayin";
                repo   = "fzf-fasd";
                rev    = "5552cdc6316ecd440a791175b8d3b1661d3dc2d7";
                sha256 = "1qvakkgjyrsz5jwyy7x7w5agbj0rrw5i1fb2rzhja5nqlkgjahk7";
              };
          }

          {
            name = "pass-zsh-completion";
            src = pkgs.fetchFromGitHub
              {
                owner  = "ninrod";
                repo   = "pass-zsh-completion";
                rev    = "e4d8d2c27d8999307e8f34bf81b2e15df4b76177";
                sha256 = "sha256-KfZJ9XxZ8cBePcJPOAPQZ+f5kVUgLExDw/5QSduDA/0=";
              };
          }
        ];
    };

    fzf = rec {
       # TODO preview doesn't work
      enable                 = true;
      defaultCommand         = "fd";
      fileWidgetCommand      = "${defaultCommand} --type f";
      fileWidgetOptions      = [ "--preview bat" ];
      changeDirWidgetCommand = "${defaultCommand} --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      historyWidgetCommand   = null;
      historyWidgetOptions   = [];
    };

    direnv = {
      # enable                     = true; # TODO
      enableNixDirenvIntegration = true;
    };

    bat.enable = true;
  };

  home.packages = with pkgs; [ fasd fd ];
}
