{ pkgs, inputs, config, ... }: let
  system = pkgs.system;
in {
  imports = [ inputs.nur.nixosModules.nur ];

  packages = with pkgs; [
    gnumake
    git
    git-crypt
    nix-prefetch-git
    nix-prefetch-github
    deploy-rs
    terranix
    (terraform.withPlugins (tp: [ tp.hcloud ]))
    config.nur.repos.rycee.mozilla-addons-to-nix
  ];

  env.GREET = "Hello to MyNixOS shell";
}
