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

  mynixos.proxy = {
    address    = "1";
    tor.enable = true;
  };

  mynixos.vpn.extIf = "ens3";
  system.stateVersion = "21.05";
}
