# My NixOS configuration

## Building

 - `make build:image:installer` to make installer image
 - `make deploy:asrock-x300.system` to deploy system profile to asrock-x300 host
 - `make deploy:asrock-x300.petrkozorezov` to deploy petrkozorezov (home-manager) profile to asrock-x300 host


## TODO

  - global:
    - nur
    - tests
    - remove copy/paste (eg font Hack)
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

## Misc

user profile is in .nix-profile

current system profile is in /run/current-system/

all system profiles in /nix/var/nix/profiles/system/

switch to profile '${profile}/bin/switch-to-configuration switch'

## Useful links

  - [LEXUGE/nixos](https://github.com/LEXUGE/nixos)
  - [YubiKey-Guide](https://github.com/drduh/YubiKey-Guide)
  - https://github.com/srid/nix-config
