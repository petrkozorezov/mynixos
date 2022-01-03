{ pkgs, ... }:
{
  programs.mako = {
    enable = true;

    defaultTimeout  = 5000       ;
    ignoreTimeout   = true       ;
    font            = "Hack 9"   ;
    backgroundColor = "#801a00D0";
    textColor       = "#ffffffD0";
    borderColor     = "#cc2900D0";
    progressColor   = "#cc2900D0";
  };

  home.packages = [ pkgs.hack-font ];
}
