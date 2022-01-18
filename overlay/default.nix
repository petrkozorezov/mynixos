self: super:
rec {
  # just to ensure overlay works
  test = super.hello;

  # erlang related packages
  grapherl  = super.callPackage ./grapherl.nix  { };
  hamler    = super.callPackage ./hamler.nix    { };
  beam      = super.beam // {
    packages = super.beam.packages // {
      erlang = super.beam.packages.erlangR24;
    };
  };
  erlang = super.erlangR24;
  firefox-addons = super.callPackage (
    { pkgs, fetchurl, lib, stdenv }:
      import ./generated-firefox-addons.nix {
        inherit fetchurl lib stdenv;
        buildFirefoxXpiAddon = pkgs.nur.repos.rycee.firefox-addons.buildFirefoxXpiAddon;
      }
  ) { };

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
      version = "11.0.2";
      src =
        super.fetchurl {
          url    = "https://dist.torproject.org/torbrowser/${version}/tor-browser-linux64-${version}_en-US.tar.xz";
          sha256 = "1bqlb8dlh92dpl9gmfh3yclq5ii09vv333yisa0i5gpwwzajnh5s";
        };
    });

  ledger-live = super.callPackage ./ledger-live.nix { };

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

  solana = super.callPackage ./solana.nix {};
}
