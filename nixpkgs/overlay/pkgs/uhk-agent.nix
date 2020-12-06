{ stdenv, appimageTools, makeWrapper, fetchurl, lib, gsettings-desktop-schemas, gtk3, electron_8, libusb, libudev }:

let
  pname = "uhk-agent";
  version = "1.5.0";
  electron = electron_8;
in

appimageTools.wrapType2 rec {
  name = "${pname}-${version}";

  src = fetchurl {
    url    = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    sha256 = "1kwp133ipxd5al9jf0v40grpnpyiqvz95yydv9rylagxllcvr2s4";
  };

  extraInstallCommands = "mv $out/bin/{${name},${pname}}";

  # nativeBuildInputs = [ makeWrapper ];

  # postFixup = ''
  #   makeWrapper ${electron}/bin/electron $out/bin/${pname} \
  #     --add-flags $out/share/${pname}/resources/app.asar \
  #     --prefix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath [ stdenv.cc.cc ]}"
  # '';

  meta = with lib; {
    description = "Ultimate hacking keyboard agent";
    homepage = "https://ultimatehackingkeyboard.com/";
    #license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = [ "x86_64-linux" ];
  };
}
