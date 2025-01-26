{
  imports = [
    ../base.nix
    ../hardware/srv1.nix

    ../dns.nix
    ../vpn.nix
    ../proxy.nix
  ];

  mynixos.proxy = {
    address    = "1";
    tor.enable = true;
  };

  mynixos.vpn.extIf = "enp1s0";
  system.stateVersion = "24.11";
}
