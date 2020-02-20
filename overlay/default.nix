self: super:
{
  mellowplayer = super.libsForQt5.callPackage pkgs/mellowplayer.nix { };

  sublime3 = super.sublime3.overrideAttrs ({propagatedBuildInputs ? [], ...}: {
    propagatedBuildInputs =
      propagatedBuildInputs ++ [ super.git ];
  });

  #xwayland = super.callPackage pkgs/xwayland.nix { };
}
