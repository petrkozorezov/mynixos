{
  imports = [
    ./router
    ./bind-ddns.nix
    ./forwarding.nix
    ./nm-connections.nix
    ./proxy.nix
    ./sss.nix
    ./terraform-state.nix
    ./vpn.nix
  ];
}
