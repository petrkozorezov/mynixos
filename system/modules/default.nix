{
  imports = [
    ./router
    ./bind-ddns.nix
    ./forwarding.nix
    ./livebook.nix
    ./nm-connections.nix
    ./proxy.nix
    ./terraform-state.nix
    ./vpn.nix
  ];
}
