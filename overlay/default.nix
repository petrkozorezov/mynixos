#
# TODO:
#  - grapherl
#
self: super:
{
  mellowplayer = super.libsForQt5.callPackage pkgs/mellowplayer.nix { };

  sublime3-dev = super.sublime3.overrideAttrs ({propagatedBuildInputs ? [], ...}: {
    propagatedBuildInputs =
      propagatedBuildInputs ++ [ super.git ];
  });

  nixops = super.callPackage pkgs/nixops.nix { };
  hey = super.callPackage pkgs/hey.nix { };

  #swayidle = super.swayidle.overrideAttrs ({src, ...}: {
  #  src = super.fetchFromGitHub {
  #    owner  = "swaywm";
  #    repo   = "swayidle";
  #    rev    = "1.6";
  #    sha256 = "1nd3v8r9549lykdwh4krldfl59lzaspmmai5k1icy7dvi6kkr18r";
  #  };
  #});

  #xwayland = super.callPackage pkgs/xwayland.nix { };
}
