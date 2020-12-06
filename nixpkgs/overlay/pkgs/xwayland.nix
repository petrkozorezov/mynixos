{ stdenv, fetchFromGitLab, autoreconfHook, wayland, wayland-protocols, xorgserver, xkbcomp, xkeyboard_config, epoxy, libxslt, libunwind, makeWrapper, fetchpatch, xorg, fontutil}:

with stdenv.lib;

xorgserver.overrideAttrs (oldAttrs: {

  name = "xwayland-${xorgserver.version}";
  buildInputs = [ autoreconfHook ] ++ oldAttrs.buildInputs;
  propagatedBuildInputs = oldAttrs.propagatedBuildInputs
    ++ [wayland wayland-protocols epoxy libxslt makeWrapper libunwind fontutil xorg.utilmacros];
  configureFlags = [
    "--disable-docs"
    "--disable-devel-docs"
    "--enable-xwayland"
    "--disable-xwayland-eglstream"
    "--disable-xorg"
    "--disable-xvfb"
    "--disable-xnest"
    "--disable-xquartz"
    "--disable-xwin"
    "--enable-glamor"
    "--with-default-font-path="
    "--with-xkb-bin-directory=${xkbcomp}/bin"
    "--with-xkb-path=${xkeyboard_config}/etc/X11/xkb"
    "--with-xkb-output=$(out)/share/X11/xkb/compiled"
  ];

  postInstall = ''
    rm -fr $out/share/X11/xkb/compiled
  '';

  meta = {
    description = "An X server for interfacing X11 apps with the Wayland protocol";
    homepage = https://wayland.freedesktop.org/xserver.html;
    license = licenses.mit;
    platforms = platforms.linux;
  };

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner  = "romangg";
    repo   = "xserver";
    rev    = "776f058bfa43fe2a1d18533190a288ad4c6d360a";
    sha256 = "14ln38zmjv8yjk0yqdigvh46fd53n2wyjfndmq998j184jjs0r0z";
  };

})
