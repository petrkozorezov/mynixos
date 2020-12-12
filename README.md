## My NixOS configuration

### Building

 - `make nixos-build` for nixos build
 - `sudo make nixos-switch` for nixos switch
 - `make nixos-build` for home-manager build
 - `make hm-switch` for home-manager switch

### Base files

 - nixpkgs.nix -- nix package manager config file (for tools like nix-shell ...)
 - configuration.nix -- base NixOS configuration file
 - home.nix -- base home-manager configuration file
 - overlay -- overlay base file

## Misc

user build is in /etc/profiles/per-user/[user]

system build is in /run/current-system/

## TODO

 - global:
  - repair overlay
  - nur
  - tests
  - remove copy/paste (eg font Hack)
  - sign and rewrite commits
 - system:
  - split to modules
  - use hardware modules only as a system capabilites
 - hm:
  - add rofi module
