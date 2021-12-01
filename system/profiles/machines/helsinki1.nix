{ pkgs, ... }:
  let
    extIf = "ens3";
  in
{
  imports = [ ../dns.nix ../vpn.nix ];

  zoo.vpn.extIf = "ens3";
}
