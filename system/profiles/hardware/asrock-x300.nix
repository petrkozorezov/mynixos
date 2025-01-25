{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./ssd-970-pro.nix
      ./audio.nix
      ./video.nix
      ./bluetooth.nix
      ./thunderbolt-devices.nix
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false; # !!!
      };
      timeout = 1;
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
    binfmt.emulatedSystems = [ "aarch64-linux" ]; # to deploy aarch64-linux
  };

  nix.settings.max-jobs = lib.mkDefault 16;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  hardware = {
    cpu.amd.updateMicrocode       = true;
    enableAllFirmware             = true;
    enableRedistributableFirmware = true;
  };

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];

  # thunderbolt control daemon
  services.hardware.bolt.enable = true;

  services.fwupd.enable = true;
}
