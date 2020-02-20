{ stdenv, fetchFromGitLab, cmake, qtbase, qttools, qtsvg, qtquickcontrols2, qtwebengine, qtgraphicaleffects, wrapQtAppsHook, pkgconfig, xorg, gdk-pixbuf, libnotify, ... }:

stdenv.mkDerivation rec {
  pname   = "mellowplayer";
  version = "3.5.10";
  # TODO application item

  src = fetchFromGitLab {
    owner  = "ColinDuquesnoy";
    repo   = "MellowPlayer";
    rev    = "${version}";
    sha256 = "1qyzswsls6hkyvmxp7z3wjkjg8vq01vwnq4v4n6aiyna4dqgki6a";
  };

  nativeBuildInputs = [ cmake wrapQtAppsHook qttools ];
  buildInputs = [ qtbase qtsvg qtquickcontrols2 qtwebengine qtgraphicaleffects pkgconfig xorg.libX11 gdk-pixbuf libnotify ];

  # qtdeclarative
  #propagatedBuildInputs = [ qt5.qtdeclarative ];

  #checkPhase = ''
  #  export QT_PLUGIN_PATH="${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}"
  #  echo "$QT_PLUGIN_PATH"
  #'';

  enableParallelBuilding = true;

  meta = {
    homepage    = https://colinduquesnoy.gitlab.io/MellowPlayer/;
    description = "MellowPlayer is a desktop application that runs web-based music streaming services";
    license     = stdenv.lib.licenses.gpl2; # TODO
    maintainers = with stdenv.lib.maintainers; [ ]; # TODO
    platforms   = with stdenv.lib.platforms; linux; # TODO
  };
}
