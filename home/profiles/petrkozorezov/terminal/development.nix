{ pkgs, deps, system, ... }:
{
  home = {
    packages = with pkgs; [
      gtypist
      pandoc

      cachix
      devenv
      gnumake
      rsync

      act # git actions local runner
    ];
  };
}
