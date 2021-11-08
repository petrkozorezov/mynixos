{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./audio.nix
      ./video.nix
      ./uhk.nix
    ];

  boot = {
    loader = {
      # when enabled deploy-rs does not wokr
      #systemd-boot.enable = true;
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
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "uas" ]; # TODO clarify
      kernelModules = [ "dm-snapshot" ];
      luks.devices.root = {
        device = "/dev/disk/by-uuid/ac46ad51-44d4-4af4-9ffd-d7911b225396";
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
  # https://christine.website/blog/paranoid-nixos-2021-07-18
  fileSystems =
    let
      brtfsSubVolume = subvol:
        {
          device        = "/dev/disk/by-uuid/3618fcf6-09bd-4cfe-8090-8dd21ce9a7e4";
          fsType        = "btrfs";
          options       = [ ("subvol=" + subvol) "compress=zstd:1" "noatime" ]; # nosuid noexec?
          neededForBoot = true;
        };
    in {
      "/"        = { fsType = "tmpfs"; device = "none"; options = [ "defaults" "size=2G" "mode=755" ]; };
      "/boot"    = { fsType = "vfat" ; device = "/dev/disk/by-uuid/C359-1E76";  };
      "/home"    = brtfsSubVolume "home";
      "/nix"     = brtfsSubVolume "nix";
      "/var/lib" = brtfsSubVolume "lib";
      "/var/log" = brtfsSubVolume "log";
      "/etc/ssh" = brtfsSubVolume "ssh";
    };

  swapDevices = [ { device = "/dev/disk/by-uuid/669e1030-cb9a-4f4f-9ba8-26324b6b9645"; } ];

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
