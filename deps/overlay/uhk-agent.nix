{ lib, pkgs, makeDesktopItem, fetchFromGitHub, ... }:
let
  pname   = "uhk-agent";
  name    = "${pname}-${version}";
  version = "1.5.13";

  src = builtins.fetchurl {
    url    = "https://github.com/UltimateHackingKeyboard/agent/releases/download/v${version}/UHK.Agent-${version}-linux-x86_64.AppImage";
    sha256 = "0q6wz0nilyrca33mdhd6jm2wr3qf9gkapva33dzv5fx9sw3c6jhf";
  };

  desktopItem = makeDesktopItem {
    name        = pname;
    desktopName = "UHK Agent";
    genericName = "Keyboard configuration";
    comment     = "Agent is the configuration application of the Ultimate Hacking Keyboard";
    icon        = "uhk-keyboard";
    terminal    = "false";
    exec        = pname;
    categories  = "Utility;";
  };

  xdgDirs = builtins.concatStringsSep ":" [
    "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}"
    "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
    "$XDG_DATA_DIRS"
  ];

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit name src;
  };

in pkgs.appimageTools.wrapType2 rec {
  inherit name src;

  multiPkgs = null;

  # Borrows Electron packages from Atom
  # Ref: https://github.com/NixOS/nixpkgs/blob/master/pkgs/applications/editors/atom/env.nix
  extraPkgs = pkgs: with pkgs; atomEnv.packages ++ [
    pciutils
    libusb1

    # Additional electron dependencies (pinning version)
    at-spi2-atk
    at-spi2-core

    # for >= 1.5.0
    libdrm
    xorg.libxshmfence
    libxkbcommon
  ];

  extraInstallCommands = ''
    ln -s "$out/bin/${name}" "$out/bin/uhk-agent"
    mkdir -p $out/etc/udev/rules.d
    cat > $out/etc/udev/rules.d/50-uhk60.rules <<EOF
    # Ultimate Hacking Keyboard rules
    # These are the udev rules for accessing the USB interfaces of the UHK as non-root users.
    # Copy this file to /etc/udev/rules.d and physically reconnect the UHK afterwards.
    SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
    KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
    EOF
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $_
    mkdir -p $out/share/icons/hicolor
    # Iterate over icons and copy them to out, dynamically
    for icon_file in $(find ${appimageContents}/usr/share/icons/hicolor -name uhk-agent.png); do
      # sed erases the appimageContents path
      install -m 444 -D $icon_file $out/share/icons/$(echo $icon_file | sed 's/.*hicolor/hicolor/')
    done
  '';

  profile = ''
    export XDG_DATA_DIRS="${xdgDirs}"
    export APPIMAGE=''${APPIMAGE-""} # Kill a seemingly useless error message
  '';

  meta = with lib; {
    description = ''
      Agent is the configuration application of the Ultimate Hacking Keyboard
    '';

    longDescription = ''
      The Ultimate Hacking Keyboard is a split mechanical keyboard which utilizes
      Cherry MX-style switches. It's also a fully programmable keyboard which
      can be vastly customized through this agent for your needs.
    '';

    homepage    = https://ultimatehackingkeyboard.com/start/agent;
    license     = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ ];
    platforms   = [ "i386-linux" "x86_64-linux" ];
  };
}
