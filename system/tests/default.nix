args@{ pkgs, ... }:
pkgs.testing.addTestAll {
  forwarding = import ./forwarding.nix args;
  sss        = import ./sss.nix        args;
  vpn        = import ./vpn.nix        args;
}
