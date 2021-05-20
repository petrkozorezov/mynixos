self: super:
rec {
  # just to ensure overlay works
  overlay-sys-test = super.hello;
  overlay-hm-test  = super.hello;

  # erlang related packages
  erlang_ls = super.callPackage ./erlang_ls.nix { };
  grapherl  = super.callPackage ./grapherl.nix  { };
  hamler    = super.callPackage ./hamler.nix    { };
  beam      = super.beam // {
    packages = super.beam.packages // {
      erlang = super.beam.packages.erlangR23;
    };
  };
  erlang = super.erlangR23;

  uhk-agent = super.callPackage ./uhk-agent.nix { };

  # wl-clipboard as a drop-in replacement to X11 clipboard tools
  wl-clipboard-x11 = super.callPackage ./wl-clipboard-x11.nix { };

  # DRM support in MellowPlayer
  libwidevinecdm = super.callPackage ./libwidevinecdm.nix { };
  mellowplayer =
    super.mellowplayer.overrideAttrs (oldAttrs: {
      buildInputs           = oldAttrs.buildInputs or [] ++ [ super.makeWrapper ];
      propagatedBuildInputs = oldAttrs.propagatedBuildInputs or [] ++ [ libwidevinecdm ];
      postInstall =
        ''
          ${oldAttrs.postInstall or ""}
          wrapProgram $out/bin/MellowPlayer \
            --set "QTWEBENGINE_CHROMIUM_FLAGS" \
              "--widevine-path=${libwidevinecdm}/lib/libwidevinecdm.so --no-sandbox"
        '';
    });
}
