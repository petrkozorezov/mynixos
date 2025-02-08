self: super:
rec {
  # just to ensure overlay works
  test = super.hello;

  bclmctl = super.callPackage ./bclmctl.nix { };
  mynixos = {
    builders = super.callPackage ./builders.nix { };
  };
}
