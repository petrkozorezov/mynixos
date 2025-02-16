{ pkgs, stdenv, fetchFromGitHub, ... }:
  stdenv.mkDerivation rec {
    pname   = "bclmctl";
    version = "1";
    src     = fetchFromGitHub {
      owner  = "petrkozorezov";
      repo   = "bclmctl";
      rev    = "297e5486ab122cca0f11d342d287f68993c614b5";
      sha256 = "bmotdK/qzqgDSBjliLG9/5Ctzr66HBWTz5izAqjCrW8=";
    };

    installPhase = ''
      ${pkgs.coreutils}/bin/install -D -t $out/sbin/ ${pname}
    '';
  }
