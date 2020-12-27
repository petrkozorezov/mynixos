## My NixOS configuration

### Building

 - `make build` for nixos and home-manager build
 - `sudo make switch` for nixos and home-manager switch

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
  - nur
  - tests
  - remove copy/paste (eg font Hack)
  - sign and rewrite commits
  - add router configuration
 - system:
  - split to modules
  - use hardware modules only as a system capabilites
 - hm:
  - rofi
   - https://github.com/davatorium/rofi/wiki/User-scripts
  - migrate to pass form keepassx
  - add after switching to radeon:
   - imv
   - mpv
   - oguri | Wallutils | smth else
  - install sublime plugins by nix
