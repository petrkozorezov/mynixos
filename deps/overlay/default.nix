self: super:
rec {
  # just to ensure overlay works
  test = super.hello;

  firefox-addons = super.callPackage ./firefox-addons.nix { };
  bclmctl        = super.callPackage ./bclmctl.nix { };

  # build-support ?
  testing.addTestAll =
    tests:
      super.callPackage (
        { pkgs, lib, stdenv, ... }:
          (tests // {
            all = (pkgs.stdenv.mkDerivation {
              name              = "tests-all";
              phases            = [ "fakeBuildPhase" ];
              fakeBuildPhase    = "echo true > $out";
              nativeBuildInputs = map (test: if lib.isDerivation test then test else test.all) (lib.attrValues tests);
            });}
          )
        ) {};
}
