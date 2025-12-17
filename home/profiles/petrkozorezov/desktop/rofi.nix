{ pkgs, config, ... }: {
  programs.rofi = {
    enable      = true;
    package     = pkgs.rofi;
    terminal    = config.home.sessionVariables.TERMINAL;
    extraConfig = {
      matching = "fuzzy";
    };
  };
}

