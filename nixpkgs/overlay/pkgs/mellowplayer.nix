{ stdenv, fetchFromGitLab, fetchzip, cmake, qtbase, qttools, qtsvg, qtquickcontrols2, qtwebengine, qtgraphicaleffects, wrapQtAppsHook, pkgconfig, xorg, gdk-pixbuf, libnotify, ... }:

stdenv.mkDerivation rec {
  pname   = "mellowplayer";
  version = "3.6.4";

  src = fetchFromGitLab {
    owner  = "ColinDuquesnoy";
    repo   = "MellowPlayer";
    rev    = "${version}";
    sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
  };

  widevine = fetchzip {
    url       = "https://dl.google.com/widevine-cdm/4.10.1582.2-linux-x64.zip";
    sha256    = "0ya0kipbf4wqgykfdkb0q71g0r3zanx3kaqmyr94lf7hiyy8rszl";
    stripRoot = false;
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook pkgconfig ];
  buildInputs = [ qtbase qttools qtsvg qtquickcontrols2 qtwebengine qtgraphicaleffects xorg.libX11 gdk-pixbuf libnotify ];

  enableParallelBuilding = true;

  postInstall = "
    mkdir $out/share/mellowplayer/plugins/ppapi/ &&
    cp ${widevine}/libwidevinecdm.so $out/share/mellowplayer/plugins/ppapi/.
  ";

  meta = {
    homepage    = https://colinduquesnoy.gitlab.io/MellowPlayer/;
    description = "MellowPlayer is a desktop application that runs web-based music streaming services";
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ]; # TODO
    platforms   = with stdenv.lib.platforms; linux;
  };
}

#QTWEBENGINE_CHROMIUM_FLAGS="--widevine-path=/nix/store/vxjlcgdfb6id3gax45xg58cbwddzwqcf-mellowplayer-3.6.4/share/mellowplayer/plugins/ppapi/libwidevinecdm.so --no-sandbox"