{ pkgs, ... }:
  let
    extIf = "ens3";
  in
{
  imports = [
    ../base.nix
    ../hardware/hetzner-cloud.nix

    ../dns.nix
    ../vpn.nix
    ../proxy.nix
  ];

  zoo.proxy = {
    address    = "1";
    tor.enable = true;
  };

  zoo.vpn.extIf = "ens3";
  system.stateVersion = "21.05";
}
