{ pkgs, lib, ... }: {
  imports = [
    ../sss.nix
    ./desktop
    ./terminal
  ];

  home = {
    packages     = with pkgs; [ test ]; # hm overlay is working
    stateVersion = lib.mkForce "20.09";
  };

  programs.home-manager.enable = true;
}
