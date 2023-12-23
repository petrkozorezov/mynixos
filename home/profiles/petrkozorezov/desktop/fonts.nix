{ pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # TODO move it in place
    # powerline-fonts
    font-awesome
#    (nerdfonts.override { fonts = ["Iosevka"]; })
  ];
}
