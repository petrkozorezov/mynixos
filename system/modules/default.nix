{
  imports = [
    ./router
    ./backups.nix
    ./dns.nix
    ./forwarding.nix
    ./metrics.nix
    ./nm-connections.nix
    ./proxy.nix
    ./terraform-state.nix
    ./vpn.nix
    ./webserver.nix
  ];
}
