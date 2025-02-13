{ pkgs, config, ... }: {
  programs.rofi = {
    enable      = true;
    package     = pkgs.rofi-wayland;
    terminal    = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      matching = "fuzzy";
    };
  };
}

