{ config, pkgs, deps, ... }: {
  programs = {
    zsh = {
      enable = true;
      dotDir = "${config.xdg.configHome}/zsh"; # FIXME remove hardcode
      initContent = # FIXME remove path manipulation
        ''
          # TODO fix 'nsh hello -c hello'
          nsh() {
            nix shell "mynixos#$1"
          }
          nshu() {
            nix shell "github:NixOS/nixpkgs/nixpkgs-unstable#$1"
          }
          fix-touchpad() {
            sudo rmmod bcm5974 && sudo modprobe bcm5974 && dmesg | tail
          }
        '';
      autocd = true;
      history = {
        expireDuplicatesFirst = true;
        extended              = true;
      };
      enableCompletion = true;
      # https://zaiste.net/posts/shell-commands-rust/
      shellAliases = rec {
        "."     = "${"ll"}";
        ".."    = "..";
        "..."   = "../..";
        "...."  = "../../..";
        "....." = "../../../..";
        "l"     = "${pkgs.eza}/bin/eza --group-directories-first";
        "ll"    = "${"l"} -l -b --git --icons --octal-permissions --no-permissions";
        "lll"   = "${"l"} -l -g";
        "ls"    = "${"l"}";
        "tree"  = "${"l"} -T";
        "ns"    = "nix search mynixos";
        "nsu"   = "nix search github:NixOS/nixpkgs/nixpkgs-unstable";
        "nb"    = "nix build";
        "noidle" = ''
          echo "Press Ctrl+C to interrupt..." && \
          systemd-inhibit --what=idle --mode=block --who="noidle" --why="Manual prevent from sleep" sleep infinity
        '';
      };
      oh-my-zsh = {
        enable  = true;
        plugins = [ "git" "sudo" ];
      };
      plugins = [
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
        {
          name = "skim-zoxide";
          src  = ./skim-zoxide;
        }
      ];
    };

    starship.enableZshIntegration = true;
    zoxide.enableZshIntegration   = true;
    direnv.enableZshIntegration   = true;
    carapace.enableZshIntegration = true;
    skim.enableZshIntegration     = true;
  };

  home.packages = [ pkgs.perl ]; # zsh skim doesn't work without it
}
