{ config, slib, ... }: {
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
    ext = {
      address = config.tfattrs.hcloud_server.srv1.ipv4_address;
      interface = "enp1s0";
    };
    int = {
      address = config.tfattrs.hcloud_server_network.srv1-network.ip;
      interface = "enp7s0";
    };
    vpn.interface = "wg0";
  in {
    proxy = {
      inherit (int) address;
      interfaces = [ int.interface vpn.interface ];
      tor.enable = true;
    };
    vpn.extIf = ext.interface;
    dns = {
      ext.address = ext.address;
      int.address = int.address;
    };
    webserver = {
      ext.address = ext.address;
      int.address = int.address;
    };
  };

  system.stateVersion = "24.11";
}
