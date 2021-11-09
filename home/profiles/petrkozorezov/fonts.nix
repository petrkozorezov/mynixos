{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    powerline-fonts
    font-awesome
    hack-font
    jetbrains-mono
#    (nerdfonts.override { fonts = ["Iosevka"]; })
  ];
}
