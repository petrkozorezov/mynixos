{ config, pkgs, deps, ... }:
{
  programs = {
    zsh = {
      enable = true;
      dotDir = ".config/zsh"; # FIXME remove hardcode
      initExtra = # FIXME remove path manipulation
        ''
          # TODO fix 'nsh hello -c hello'
          nsh() {
            nix shell "mynixos#$1"
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
        "cat"   = "${pkgs.bat}/bin/bat";
        "ns"    = "nix search mynixos";
        "nb"    = "nix build";
        "cloc"  = "${pkgs.tokei}/bin/tokei";
        "grep"  = "${pkgs.ripgrep}/bin/rg";
        "find"  = "${pkgs.fd}/bin/fd";
        "ps"    = "${pkgs.procs}/bin/procs";
        "du"    = "${pkgs.du-dust}/bin/dust";
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
}
