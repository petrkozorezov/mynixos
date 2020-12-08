{ ... }:
{
  security.polkit.enable = true;
  services = {
    flatpak.enable  = false;
    udev = {
      extraRules = ''
        SUBSYSTEM=="input", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", GROUP="input", MODE="0660"
        SUBSYSTEMS=="usb", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
        KERNEL=="hidraw*", ATTRS{idVendor}=="1d50", ATTRS{idProduct}=="612[0-7]", TAG+="uaccess"
      '';
    };
  };
}