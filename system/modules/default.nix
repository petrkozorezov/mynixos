{
  imports = [
    ./router
    ./backups.nix
    ./bind-ddns.nix
    ./forwarding.nix
    ./nm-connections.nix
    ./proxy.nix
    ./terraform-state.nix
    ./vpn.nix
  ];
}
