# My NixOS configuration

## Building

 - `make build` for nixos and home-manager build
 - `sudo make switch` for nixos and home-manager switch


## Base files

 - nixpkgs.nix — nix package manager config file (for tools like nix-shell …)
 - configuration.nix — base NixOS configuration file
 - home.nix — base home-manager configuration file
 - overlay — overlay base file
 - image.nix — iso image of this configuration


## TODO

  - global:
    - nur
    - tests
    - remove copy/paste (eg font Hack)
    - add router configuration
  - system:
    - split to modules
    - use hardware modules only as a system capabilites
  - security:
    - programs.rofi.pass.enable = true; https://github.com/carnager/rofi-pass/
    - https://github.com/maximbaz/yubikey-touch-detector
    - https://github.com/palortoff/pass-extension-tail#readme
  - hm:
    - rofi
      - https://github.com/davatorium/rofi/wiki/User-scripts
    - add after switching to radeon:
      - imv
      - mpv
      - oguri | Wallutils | smth else
    - install sublime plugins by nix (subl plugins do not work on livecd without an internet)
  - router
    - installer
    - deploy nixos
    - add dnsmasq
    - add nat
    - add wifi access point
    - Ddns
    - VPN server+client
    - Homeassist server
    - Syncthing

## NixOPS

 - https://github.com/wagdav/homelab
 - https://lukebentleyfox.net/posts/building-this-blog/

## Misc

user build is in /etc/profiles/per-user/[user]

system build is in /run/current-system/


## Useful links

  - [LEXUGE/nixos](https://github.com/LEXUGE/nixos)
  - [YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
