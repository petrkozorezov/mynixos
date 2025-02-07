self: super:
rec {
  # just to ensure overlay works
  test = super.hello;

  firefox-addons = super.callPackage ./firefox-addons.nix { };
  bclmctl        = super.callPackage ./bclmctl.nix { };
  mynixos = {
    builders = super.callPackage ./builders.nix { };
  };
}
