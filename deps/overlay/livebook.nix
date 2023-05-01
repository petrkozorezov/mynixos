{ lib, makeWrapper, rebar3, elixir_1_14, erlang, fetchgit, beam, ...}:
  let
    packages = beam.packagesWith beam.interpreters.erlang;
  in packages.mixRelease rec {
    pname    = "livebook";
    version  = "0.9.2";

    elixir = elixir_1_14;

    buildInputs = [ erlang ];
    nativeBuildInputs = [ makeWrapper ];

    src = fetchgit {
      url = "https://github.com/livebook-dev/livebook.git";
      rev = "v${version}";
      sha256 = "khC3gtRvywgAY6qHslZgAV3kmziJgKhdCB8CDg/HkIU=";
    };

    mixFodDeps = packages.fetchMixDeps {
      pname = "mix-deps-${pname}";
      inherit src version;
      sha256 = "rwWGs4fGeuyV6BBFgCyyDwKf/YLgs1wY0xnHYy8iioE=";
    };

    installPhase = ''
      mix escript.build
      mkdir -p $out/bin
      mv ./livebook $out/bin

      wrapProgram $out/bin/livebook \
        --suffix PATH : ${lib.makeBinPath [ elixir ]} \
        --set MIX_REBAR3 ${rebar3}/bin/rebar3
    '';
  }
