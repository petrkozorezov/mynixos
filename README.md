# My NixOS configuration

## Building

 - `make build` for nixos and home-manager build
 - `sudo make switch` for nixos and home-manager switch


## Base files

 - nixpkgs.nix — nix package manager config file (for tools like nix-shell …)
 - system/ — NixOS configuration files
 - home/ — home-manager configuration file
 - overlay/ — nixpkgs overlay
 - image.nix — iso image of this configuration


## TODO

  - global:
    - nur
    - tests
    - remove copy/paste (eg font Hack)
    - switch to deploy-rs + terraform (???)
  - system:
    - use hardware modules only as a system capabilites
  - security:
    - programs.rofi.pass.enable = true; https://github.com/carnager/rofi-pass/
    - https://github.com/maximbaz/yubikey-touch-detector
    - https://github.com/palortoff/pass-extension-tail#readme
  - hm:
    - rofi
      - https://github.com/davatorium/rofi/wiki/User-scripts
    - oguri | Wallutils | smth else
    - install sublime plugins by nix (subl plugins do not work on livecd without an internet)
  - infrastructure
    - DDNS
    - VPN server+client
    - Homeassist server
    - Syncthing
    - [monitoring](https://github.com/hacklschorsch/nixos-cluster-monitoring-sandbox)

## NixOPS

 - https://github.com/wagdav/homelab
 - https://lukebentleyfox.net/posts/building-this-blog/

## Misc

user build is in /etc/profiles/per-user/[user]

system build is in /run/current-system/


## Useful links

  - [LEXUGE/nixos](https://github.com/LEXUGE/nixos)
  - [YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
  - https://github.com/srid/nix-config
