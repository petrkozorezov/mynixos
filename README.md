# My NixOS configuration

## Building

 - `make shell` to start shell with the all required software

## TODO

  - global:
    - tests
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
  - https://github.com/srid/nixos-config
  - https://github.com/maxhbr/myconfig
  - screen capture test https://mozilla.github.io/webrtc-landing/gum_test.html
