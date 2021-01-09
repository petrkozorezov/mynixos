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
      net        = "192.168.2";
      ethernet.interface = "enp4s0";
      wireless = {
        interface  = "wlp0s20u4u4";
        channel    = 1;
        ssid       = "Petrovi4New";
        passphrase = "testpassword";
      };
      hosts = {
        mbp = {
          # TODO more than one
          # 80:e6:50:06:55:ea
          mac = "ac:87:a3:0c:83:96";
          ip  = "50";
        };
      };
    };
  };
}
