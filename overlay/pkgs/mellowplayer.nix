{ stdenv, fetchFromGitLab, cmake, qtbase, qttools, qtsvg, qtquickcontrols2, qtwebengine, qtgraphicaleffects, wrapQtAppsHook, pkgconfig, xorg, gdk-pixbuf, libnotify, ... }:

stdenv.mkDerivation rec {
  pname   = "mellowplayer";
  version = "3.5.10";

  src = fetchFromGitLab {
    owner  = "ColinDuquesnoy";
    repo   = "MellowPlayer";
    rev    = "${version}";
    sha256 = "1qyzswsls6hkyvmxp7z3wjkjg8vq01vwnq4v4n6aiyna4dqgki6a";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook pkgconfig ];
  buildInputs = [ qtbase qttools qtsvg qtquickcontrols2 qtwebengine qtgraphicaleffects xorg.libX11 gdk-pixbuf libnotify ];

  enableParallelBuilding = true;

  meta = {
    homepage    = https://colinduquesnoy.gitlab.io/MellowPlayer/;
    description = "MellowPlayer is a desktop application that runs web-based music streaming services";
    license     = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ ]; # TODO
    platforms   = with stdenv.lib.platforms; linux;
  };
}
