{ pkgs, ... }: {
  # TODO:
  #  - git aliases (mb https://gist.github.com/spitfire05/103324f015d12c661f5da9e329852ad0 ?)
  #  - nu_scripts (eg git/gh/nix completions)
  #  - skim integration # https://github.com/nushell/nushell/issues/1275
  #  - plugins
  #  - nix-index as command-not-found
  programs = {
    nushell = {
      enable  = true;
      package = pkgs.nushellFull;
      shellAliases = {
        "."    = "ls";
        "l"    = "ls";
        "cat"  = "${pkgs.bat}/bin/bat";
        "ns"   = "nix search mynixos";
        "nb"   = "nix build";
        "cloc" = "${pkgs.tokei}/bin/tokei";
      };
      extraConfig = ''
        $env.config = {
          show_banner: false
        }

        def noidle [] {
          echo "Press Ctrl+C to interrupt..."
          systemd-inhibit --what=idle --mode=block --who="noidle" --why="Manual prevent from sleep" sleep infinity
        }

        def fix-touchpad [] {
          sudo rmmod bcm5974
          sudo modprobe bcm5974
          dmesg | tail
        }

        # TODO args (https://github.com/nushell/nushell/discussions/7457)
        def nsh [ pkg: string ] {
          nix shell $'mynixos#($pkg)'
        }
      '';
    };

    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration   = true;
    direnv.enableNushellIntegration   = true;
    carapace.enableNushellIntegration = true;
  };
}
