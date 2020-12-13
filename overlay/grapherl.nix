{ beam, graphviz, fetchFromGitHub, lib }:

beam.packages.erlang.buildRebar3 rec {
  name = "grapherl";
  version = "master";

  src = fetchFromGitHub {
    owner  = "eproxus";
    repo   = name;
    rev    = version;
    sha256 = "0n1ah23daj255ldlzgjaq15bf9lh2jzqya8541f952jps3gdyk3g";
  };

  buildPhase = ''
    HOME=. rebar3 escriptize
  '';

  installPhase = ''
    mkdir -p $out/bin/
    cp -r _build/default/bin/${name} "$out/bin/"
  '';

  meta = with lib; {
    description = "Create graphs of Erlang systems and programs";
    homepage    = "https://github.com/eproxus/grapherl/";
    license     = "Apache-2.0";
    maintainers = with maintainers; [ ];
    platforms   = with platforms; linux;
  };
}
