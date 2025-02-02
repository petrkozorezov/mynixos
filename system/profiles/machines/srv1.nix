{
  imports = [
    ../base.nix
    ../hardware/srv1.nix
    ../backups.nix

    ../dns.nix
    ../vpn.nix
    ../proxy.nix
    ../syncthing.nix
  ];

  mynixos.proxy = {
    address    = "1";
    tor.enable = true;
    interface  = "wg0";
  };

  mynixos.vpn.extIf = "enp1s0";
  system.stateVersion = "24.11";
}
