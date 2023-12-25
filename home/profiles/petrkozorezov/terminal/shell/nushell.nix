{ pkgs, ... }: {
  # TODO
  #  - git aliases
  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        "." = "ls";
        "l" = "ls";
        "cat"   = "${pkgs.bat}/bin/bat";
        "ns"    = "nix search mynixos";
        "nb"    = "nix build";
        "cloc"  = "${pkgs.tokei}/bin/tokei";
        # "noidle" = ''
        #   echo "Press Ctrl+C to interrupt..."
        #   systemd-inhibit --what=idle --mode=block --who="noidle" --why="Manual prevent from sleep" sleep infinity
        # '';
          # nsh() {
          #   nix shell "mynixos#$1"
          # }
          # fix-touchpad() {
          #   sudo rmmod bcm5974 && sudo modprobe bcm5974 && dmesg | tail
          # }
      };
      extraConfig = ''
        $env.config = {
          show_banner: false
        }
      '';
    };

    starship.enableNushellIntegration = true;
    zoxide.enableNushellIntegration   = true;
    direnv.enableNushellIntegration   = true;
    carapace.enableNushellIntegration = true;
  };
}
