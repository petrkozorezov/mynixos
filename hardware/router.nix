{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "ahci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ config.boot.kernelPackages.rtl8192eu ];
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = false;
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/b238dc86-2bff-44f7-ade3-e7cf784b05db";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/0EF4-472D";
      fsType = "vfat";
    };

  swapDevices = [ ];
}
