{ config, ... }: {
  imports = [
    ../base.nix
    ../hardware/srv1.nix

    ../backups.nix
    ../dns.nix
    ../proxy.nix
    ../syncthing.nix
    ../vpn.nix
    ../webserver.nix
    ../metrics.nix
  ];

  mynixos = let
    extAddress = config.tfattrs.hcloud_server.srv1.ipv4_address;
    intAddress = "${config.mynixos.secrets.vpnSubnet}.${config.mynixos.secrets.vpn.srv1.addr}"; # TODO find better way to construct;
  in {
    proxy = {
      address    = config.mynixos.secrets.vpn.srv1.addr;
      tor.enable = true;
      interface  = "wg0";
    };
    vpn.extIf = "enp1s0";
    dns = {
      ext.address = extAddress;
      int.address = intAddress;
    };
    webserver = {
      ext.address = extAddress;
      int.address = intAddress;
    };
  };

  system.stateVersion = "24.11";
}
