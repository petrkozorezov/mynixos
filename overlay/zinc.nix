{ stdenv, fetchzip, lib, ... }:
stdenv.mkDerivation rec {
  pname   = "zinc";
  version = "0.2.3";
  name    = "${pname}-${version}";

  src = fetchzip {
    url       = "https://github.com/matter-labs/zinc/releases/download/${version}/zinc-${version}-linux.tar.gz";
    hash      = "sha256-vmX5MaHEO60DGM7nYS0sKdhigZYGWvdsc8hO0yNwjyg=";
    stripRoot = false;
  };

  installPhase = ''
    mkdir -p $out/bin
    cp zinc-${version}-linux/{zargo,znc,zvm} $out/bin/.
  '';

  meta = with lib; {
    description = "The Zinc language public repository ";
    homepage    = "https://zksync.io/";
    license     = licenses.asl20;
    platforms   = platforms.linux;
  };
}
