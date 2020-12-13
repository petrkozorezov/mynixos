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
    broken = true;
  };
}
