{ pkgs, lib, ... }:
{
  imports =
    [
      ../hardware/router.nix
    ];

  nixpkgs = (import ../nixpkgs.nix);

  deployment.targetHost = "192.168.1.200";

  zoo.router = {
    enable     = true;
    hostname   = "router-new"; # TODO rename
    domain     = "zoo";

    uplink = {
      interface = "enp3s0";
    };

    local = {
      interface = "enp4s0";
      net       = "192.168.2";
      hosts = {
        mbp = {
          mac = "ac:87:a3:0c:83:96";
          ip  = "50";
        };
      };
    };
  };
}
