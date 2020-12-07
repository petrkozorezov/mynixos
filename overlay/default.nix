self: super:
{
  mellowplayer = super.libsForQt5.callPackage pkgs/mellowplayer.nix { };

  sublime3 = super.sublime3.overrideAttrs ({propagatedBuildInputs ? [], nativeBuildInputs ? [], ...}: {
    # propagatedBuildInputs =
    #   propagatedBuildInputs ++ [ super.git ];
  });

  hey = super.callPackage pkgs/hey.nix { };

  uhk-agent = super.callPackage pkgs/uhk-agent.nix { };
  grapherl  = super.callPackage pkgs/grapherl.nix { };
  #nixops = super.callPackage pkgs/nixops.nix { };

  spark = super.callPackage <nixpkgs/pkgs/applications/networking/cluster/spark> {
    mesosSupport = false;
  };

  hamler = super.callPackage pkgs/hamler.nix { };

  # mesos = super.mesos.overrideAttrs ({buildInputs, ...}: {
  #   # buildInputs           = buildInputs ++ [ super.python27Packages.protobuf ];
  #   # propagatedBuildInputs = [];
  #   pythonProtobuf = super.pythonPackages.protobuf.override {
  #     #protobuf = super.protobuf3_8;
  #   };
  #   meta.broken           = false;
  # });


  #firmwareLinuxNonfree = super.callPackage pkgs/linux-firmaware.nix { };

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
