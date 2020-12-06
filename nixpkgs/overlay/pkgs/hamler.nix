{ stdenv, fetchurl, makeWrapper, erlang, zlib, ncurses5, gmp, lib, patchelf }:

stdenv.mkDerivation rec {
  version = "0.2";
  pname = "hamler";
  name = "${pname}-${version}";

  src = fetchurl {
    url    = "https://github.com/hamler-lang/hamler/releases/download/${version}/${name}.tgz";
    sha256 = "1jcfijmk98paj3c1sxgq6mzw8fmxwzxrgkgf8af61zhym5k7gnms";
  };

  nativeBuildInputs = [ patchelf ];
  buildInputs = [ patchelf ];
  propogatedBuildInputs = [ erlang zlib gmp ncurses5 ];

  rpath = "${lib.makeLibraryPath propogatedBuildInputs}";

  installPhase = ''
    mkdir -p $out/
    cp -r * $out/
  '';

  postFixup = ''
    patchelf \
        --set-interpreter "${stdenv.cc.bintools.dynamicLinker}" \
        --set-rpath "${rpath}" \
        $out/bin/${pname}
  '';
  # --set-rpath "${rpath}" \

  meta = with stdenv.lib; {
    description = "Haskell-style functional programming language running on Erlang VM. ";
    homepage = "https://www.hamler-lang.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}

# { mkDerivation, aeson, aeson-better-errors, aeson-pretty
# , ansi-terminal, ansi-wl-pprint, base, base-compat, boxes
# , bytestring, Cabal, containers, CoreErlang, directory, file-embed
# , filepath, gitrev, Glob, happy, haskeline, hpack, hspec
# , hspec-discover, HUnit, language-javascript, lens, lifted-async
# , lifted-base, monad-control, mtl, optparse-applicative, parsec
# , pattern-arrows, pretty, pretty-simple, process, protolude
# , purescript, safe, semialign, semigroups, shelly, sourcemap
# , stdenv, tasty, tasty-golden, tasty-hspec, tasty-quickcheck
# , template-haskell, text, time, transformers, transformers-base
# , transformers-compat, utf8-string, fetchFromGitHub
# }:
# mkDerivation rec {
#   pname = "hamler";
#   version = "0.2";
#   src = fetchFromGitHub {
#     owner = "hamler-lang";
#     repo = "hamler";
#     rev = "${version}";
#     sha256 = "163wg0xb7w5mwh6wrfarzcgaf6c7gb5qydgpi2wk35k551f7286s";
#   };
#   isLibrary = true;
#   isExecutable = true;
#   libraryHaskellDepends = [
#     aeson aeson-better-errors aeson-pretty ansi-terminal base
#     base-compat boxes bytestring Cabal containers CoreErlang directory
#     file-embed filepath Glob haskeline language-javascript lens
#     lifted-async lifted-base monad-control mtl parsec pattern-arrows
#     pretty pretty-simple process protolude purescript safe semialign
#     semigroups shelly sourcemap template-haskell text time transformers
#     transformers-base transformers-compat utf8-string
#   ];
#   libraryToolDepends = [ happy hpack ];
#   executableHaskellDepends = [
#     aeson aeson-better-errors aeson-pretty ansi-terminal ansi-wl-pprint
#     base base-compat boxes bytestring Cabal containers CoreErlang
#     directory file-embed filepath gitrev Glob haskeline
#     language-javascript lens lifted-async lifted-base monad-control mtl
#     optparse-applicative parsec pattern-arrows pretty pretty-simple
#     process protolude purescript safe semialign semigroups shelly
#     sourcemap template-haskell text time transformers transformers-base
#     transformers-compat utf8-string
#   ];
#   executableToolDepends = [ happy ];
#   testHaskellDepends = [
#     aeson aeson-better-errors aeson-pretty ansi-terminal base
#     base-compat boxes bytestring Cabal containers CoreErlang directory
#     file-embed filepath Glob haskeline hspec hspec-discover HUnit
#     language-javascript lens lifted-async lifted-base monad-control mtl
#     optparse-applicative parsec pattern-arrows pretty pretty-simple
#     process protolude purescript safe semialign semigroups shelly
#     sourcemap tasty tasty-golden tasty-hspec tasty-quickcheck
#     template-haskell text time transformers transformers-base
#     transformers-compat utf8-string
#   ];
#   testToolDepends = [ happy hspec-discover ];
#   prePatch = "hpack";
#   homepage = "https://hamler-lang.org/";
#   description = "The Hamler Programming Language";
#   license = stdenv.lib.licenses.bsd3;
# }
