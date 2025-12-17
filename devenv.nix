{ config, pkgs, ... }: let
  system = pkgs.stdenv.hostPlatform.system;
  terraformPkg = with pkgs; (terraform.withPlugins (tp: [ tp.hetznercloud_hcloud ]));
in {
  packages = with pkgs; [
    gnumake
    git
    git-crypt
    nix-prefetch-git
    nix-prefetch-github
    deploy-rs.deploy-rs
    home-manager
    devenv
  ];

  env.GREET = "Hello to MyNixOS shell";

  scripts.terraform.exec =
    "${pkgs.terranix}/bin/terranix ${config.devenv.root}/cloud/default.nix | jq . > ${config.devenv.root}/config.tf.json && ${terraformPkg}/bin/terraform $@";
}
