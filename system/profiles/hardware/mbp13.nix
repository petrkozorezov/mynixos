{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./audio.nix
      ./video.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable           = true;
        version          = 2;
        device           = "nodev";
        efiSupport       = true;
        enableCryptodisk = true;
      };
      timeout            = 1;
    };
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ]; # TODO clarify
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = {
        device = "/dev/disk/by-uuid/f7c8f555-598b-44f7-b0c3-ade87844c132";
        preLVM = true;
      };
    };
    kernelModules = [ "kvm-intel" "wl" ];
    extraModulePackages = [
      config.boot.kernelPackages.broadcom_sta
    ];
  };

  # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  # https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/
  fileSystems =
    let
      brtfsSubVolume = subvol:
        {
          device  = "/dev/disk/by-uuid/34b13e2b-81a7-4aba-936a-274916124b23";
          fsType  = "btrfs";
          options = [ ("subvol=" + subvol) "compress=zstd:1" "noatime" ];
        };
      # baseOpts = ;
    in {
      "/"        = { fsType = "tmpfs"; device = "none"; options = [ "defaults" "size=2G" "mode=755" ]; };
      "/boot"    = { fsType = "vfat" ; device = "/dev/disk/by-uuid/F92B-ADC1";  };
      "/home"    = brtfsSubVolume "home";
      "/nix"     = brtfsSubVolume "nix";
      "/var/lib" = brtfsSubVolume "lib";
      "/var/log" = brtfsSubVolume "log";
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/66be6355-c124-4035-928a-ce2e904893f5"; } ];

  # high-resolution display

  nix.maxJobs = lib.mkDefault 4;
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  # High-DPI console

  # TODO clarify
  services = {
    fwupd.enable  = true;
    tlp.enable    = true;
    upower.enable = true;
  };

  hardware = {
    enableAllFirmware             = true;
    cpu.intel.updateMicrocode     = true;
    enableRedistributableFirmware = true;
  };

  # facetimehd
  hardware.facetimehd.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # video
  hardware.video.hidpi.enable = lib.mkDefault true;
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  programs.light.enable = true; # backlight control
}
