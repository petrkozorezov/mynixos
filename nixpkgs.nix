{
  config   = (import ./config.nix);
  overlays = [ (import ./overlay) ];
}
