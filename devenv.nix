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
    # use the same deploy-rs for 'deploy' command and for flake.nix activation package
    inputs.deploy-rs.defaultPackage."${system}"
    terranix
    (terraform.withPlugins (tp: [ tp.hcloud ]))

    # TODO move to packages build deps
    ripgrep
    curl
    config.nur.repos.rycee.mozilla-addons-to-nix
  ];

  env.GREET = "Hello to MyNixOS shell";
}
