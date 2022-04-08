{ stdenv, fetchFromGitHub, wl-clipboard }:

stdenv.mkDerivation rec {
  pname   = "wl-clipboard-x11";
  version = "5";

  src = fetchFromGitHub {
    owner  = "brunelli";
    repo   = "wl-clipboard-x11";
    rev    = "v${version}";
    sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
  };

  dontBuild             = true;
  dontConfigure         = true;
  propagatedBuildInputs = [ wl-clipboard ];
  makeFlags             = [ "PREFIX=$(out)" ];
}
