{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      erlang
      gnumake
      cloc
      gtypist
      sublime3
      grapherl

      # TODO ops
      # nixops
    ];
}
