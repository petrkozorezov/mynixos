{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./ssd-970-pro.nix
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" "wl"];
    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
    ];
    # loader = {
    #   efi.canTouchEfiVariables = true;
    #   systemd-boot.consoleMode = "max";
    # };
  };

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
    facetimehd.enable             = true;
    bluetooth.enable              = true;
    pulseaudio.extraModules       = [ pkgs.pulseaudio-modules-bt ];
  };

  services.blueman.enable          = true;
}
