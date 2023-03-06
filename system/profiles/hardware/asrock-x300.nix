{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./ssd-970-pro.nix
      ./audio.nix
      ./video.nix
      ./tp-link-archer-t4u-plus.nix
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
    extraModulePackages = [ ];
  };

  nix.settings.max-jobs = lib.mkDefault 16;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  hardware = {
    video.hidpi.enable            = lib.mkDefault true;
    enableAllFirmware             = true;
    enableRedistributableFirmware = true;
  };

  # amd vulkan
  hardware.opengl = {
    extraPackages   = with pkgs              ; [ amdvlk rocm-opencl-icd rocm-runtime ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ amdvlk libva ];
  };
  environment.variables.VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/amd_icd64.json";
}
