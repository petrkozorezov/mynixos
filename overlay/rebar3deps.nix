{ stdenv, rebar3, git, cacert }:

{ name, version, sha256, src, meta ? {}}:

with stdenv.lib;

stdenv.mkDerivation ({
  name = "rebar-deps-${name}-${version}";

  phases = [ "downloadPhase" "installPhase" ];

  buildInputs = [ git cacert ];

  downloadPhase = ''
    cp ${src} .
    HOME='.' DEBUG=1 ${rebar3}/bin/rebar3 get-deps
    rm -rf  ./_build/default/lib/redbug/.git
  '';

  installPhase = ''
    mkdir -p "$out/_checkouts"
    for i in ./_build/default/lib/* ; do
       echo "$i"
       cp -R "$i" "$out/_checkouts"
    done
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = sha256;

  impureEnvVars = stdenv.lib.fetchers.proxyImpureEnvVars;
  inherit meta;
})
