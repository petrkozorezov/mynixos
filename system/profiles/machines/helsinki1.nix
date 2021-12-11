{ pkgs, ... }:
  let
    extIf = "ens3";
  in
{
  imports = [ ../dns.nix ../vpn.nix ../proxy.nix ];

  zoo.vpn.extIf = "ens3";
}
