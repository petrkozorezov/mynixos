{ pkgs, config, ... } :
{
  isoImage = {
    isoName = "${config.system.nixos.label}-${pkgs.stdenv.hostPlatform.system}.iso";
    makeEfiBootable = true;
    makeUsbBootable = true;
  };
}
