{ pkgs, ... }: let
  system = pkgs.system;
in {
  packages = with pkgs; [
    gnumake
    git
    git-crypt
    nix-prefetch-git
    nix-prefetch-github
    deploy-rs.deploy-rs
    terranix
    (terraform.withPlugins (tp: [ tp.hcloud ]))

    devenv
  ];

  env.GREET = "Hello to MyNixOS shell";
}
