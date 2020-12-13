self: super:
{
  overlay-sys-test = super.hello;
  overlay-hm-test  = super.hello;

  sublime3 = super.sublime3.overrideAttrs ({propagatedBuildInputs ? [], nativeBuildInputs ? [], ...}: {
    # propagatedBuildInputs =
    #   propagatedBuildInputs ++ [ super.git ];
  });

  uhk-agent = super.callPackage ./uhk-agent.nix { };
  grapherl  = super.callPackage ./grapherl.nix  { };
  hamler    = super.callPackage ./hamler.nix    { };
}
