# TODO: https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134
 { config, lib, pkgs, modulesPath, ... }: let
  bootDevice = "/dev/disk/by-uuid/C359-1E76";
  luksDevice = "/dev/disk/by-uuid/ac46ad51-44d4-4af4-9ffd-d7911b225396";
in {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./audio.nix
      ./video.nix
    ];

  boot = {
    loader = {
      # when enabled deploy-rs does not work
      #systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable           = true;
        device           = "nodev";
        efiSupport       = true;
        enableCryptodisk = true;
      };
      timeout = 1;
    };
    supportedFilesystems = [ "btrfs" ];
    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "uas" ]; # TODO clarify
      kernelModules = [ "i915" "dm-snapshot" ];
      luks.devices.root = {
        device           = luksDevice;
        preLVM           = true;
        bypassWorkqueues = true;
      };
      # restore root
      postDeviceCommands = lib.mkBefore ''
        echo "restoring blank root..."
        mkdir -p /mnt
        mount -o subvol=/ /dev/mapper/lvm-root /mnt

        echo "deleting /root subvolume..."
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        umount /mnt
      '';
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
          device        = "/dev/mapper/lvm-root";
          fsType        = "btrfs";
          options       = [ ("subvol=" + subvol) "compress=zstd:1" "noatime" ]; # nosuid noexec?
          neededForBoot = true;
        };
    in {
      "/"        = brtfsSubVolume "root";
      "/boot"    = { fsType = "vfat" ; device = bootDevice;  };
      "/home"    = brtfsSubVolume "home";
      "/nix"     = brtfsSubVolume "nix";
      "/srv"     = brtfsSubVolume "srv";
      "/var/lib" = brtfsSubVolume "lib";
      "/var/log" = brtfsSubVolume "log";
      "/etc/ssh" = brtfsSubVolume "ssh";
    };

  swapDevices = [ { device = "/dev/mapper/lvm-swap"; } ];


  nix.settings.max-jobs = lib.mkDefault 4;
  #powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

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
    opengl.extraPackages          = with pkgs; [
      vaapiIntel
      libvdpau-va-gl
      intel-media-driver
    ];
  };

  environment.variables = {
    VDPAU_DRIVER = lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };

  # facetimehd
  hardware.facetimehd.enable = true;

  # bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # video
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
  programs.light.enable = true; # backlight control

  environment.systemPackages = with pkgs; [ bclmctl ];
}
