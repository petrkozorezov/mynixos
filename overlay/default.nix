self: super:
rec {
  # just to ensure overlay works
  overlay-sys-test = super.hello;
  overlay-hm-test  = super.hello;

  # erlang related packages
  grapherl  = super.callPackage ./grapherl.nix  { };
  hamler    = super.callPackage ./hamler.nix    { };
  beam      = super.beam // {
    packages = super.beam.packages // {
      erlang = super.beam.packages.erlangR24;
    };
  };
  erlang = super.erlangR24;

  zinc = super.callPackage ./zinc.nix  { };
  uhk-agent = super.callPackage ./uhk-agent.nix { };

  # wl-clipboard as a drop-in replacement to X11 clipboard tools
  wl-clipboard-x11 = super.callPackage ./wl-clipboard-x11.nix { };

  # DRM support in MellowPlayer
  # libwidevinecdm = super.callPackage ./libwidevinecdm.nix { };
  # mellowplayer =
  #   super.mellowplayer.overrideAttrs (oldAttrs: {
  #     buildInputs           = oldAttrs.buildInputs or [] ++ [ super.makeWrapper ];
  #     propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [] ++ [ libwidevinecdm ];
  #     postInstall =
  #       ''
  #         ${oldAttrs.postInstall or ""}
  #         wrapProgram $out/bin/MellowPlayer \
  #           --set "QTWEBENGINE_CHROMIUM_FLAGS" \
  #             "--widevine-path=${libwidevinecdm}/lib/libwidevinecdm.so --no-sandbox"
  #       '';
  #   });

  xterm-24bit = super.callPackage ./xterm-24bit.nix { };

  torbrowser =
    super.torbrowser.overrideAttrs (oldAttrs: rec {
      version = "10.5.5";
      src =
        super.fetchurl {
          url    = "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux64-${version}_en-US.tar.xz";
          sha256 = "0847lib2z21fgb7x5szwvprc77fhdpmp4z5d6n1sk6d40dd34spn";
        };
    });

}
