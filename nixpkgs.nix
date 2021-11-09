{
  config   = (import ./config.nix);
  overlays = [ (import ./overlay) ]; # TODO nur.overlay
}
