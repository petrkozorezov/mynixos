{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./ssd-970-pro.nix
      ./audio.nix
      ./video.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      timeout             = 1;
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    # TODO try 6.8 linux
    kernelParams  = [
      "amdgpu.ppfeaturemask=0xffffffff" # enable overclocking and tuning
    ];
    extraModulePackages = [ ];
  };

  nix.settings.max-jobs = lib.mkDefault 16;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  hardware = {
    enableAllFirmware             = true;
    enableRedistributableFirmware = true;
  };

  hardware.opengl = {
    extraPackages   = with pkgs              ; [ rocm-opencl-icd rocmPackages.rocm-runtime ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  };
}
