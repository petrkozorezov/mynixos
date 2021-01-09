{ config, lib, pkgs, ... }:

{
  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" "wl" "88x2bu" ];
    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
      config.boot.kernelPackages.rtl88x2bu
    ];

    loader = {
      systemd-boot.enable      = true;
      timeout                  = 1;
      # efi.canTouchEfiVariables = true;
      #systemd-boot.consoleMode = "max";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/e919fa4c-439e-455c-9529-f284a30434c0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2F08-52CD";
      fsType = "vfat";
    };

  swapDevices =
    [
      { device = "/dev/disk/by-uuid/66be6355-c124-4035-928a-ce2e904893f5"; }
    ];

  nix.maxJobs = lib.mkDefault 4;
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  # backlight control
  programs.light.enable = true;

  hardware = {
    enableAllFirmware             = true;
    cpu.intel.updateMicrocode     = true;
    enableRedistributableFirmware = true;
    bluetooth.enable              = true;
    pulseaudio.extraModules       = [ pkgs.pulseaudio-modules-bt ];
  };

  services.blueman.enable          = true;
}
