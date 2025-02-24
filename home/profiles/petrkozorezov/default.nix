{ pkgs, lib, ... }: {
  imports = [
    ../sss.nix
    ./stylix.nix
    ./desktop
    ./terminal
  ];

  home.packages = [ pkgs.test ]; # hm overlay is working
}
