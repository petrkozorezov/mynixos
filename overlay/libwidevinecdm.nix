{ stdenv, fetchzip, lib, ... }:
stdenv.mkDerivation rec {
  pname   = "libwidevinecdm";
  version = "4.10.1582.2";
  name    = "${pname}-${version}";

  src = fetchzip {
    url       = "https://dl.google.com/widevine-cdm/${version}-linux-x64.zip";
    sha256    = "0ya0kipbf4wqgykfdkb0q71g0r3zanx3kaqmyr94lf7hiyy8rszl";
    stripRoot = false;
  };

  installPhase =
    ''
      install -vD "${pname}.so" $out/lib/${pname}.so
    '';

  meta = with lib; {
    description = "Widevine cdm library";
    homepage    = "https://www.widevine.com";
    license     = licenses.unfree;
    platforms   = platforms.linux;
  };
}
