{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      gcc
      erlang
      rebar3
      gnumake
      cloc
      gtypist
      sublime3
      grapherl
      pandoc

      # TODO ops
      # nixops
      nix-prefetch-git
    ];
}
