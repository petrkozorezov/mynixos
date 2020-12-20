{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      erlang
      rebar3
      gnumake
      cloc
      gtypist
      sublime3
      grapherl

      # TODO ops
      # nixops
      nix-prefetch-git
    ];
}
