{
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
    [{
      device = "/var/lib/swapfile";
      size   = 16 * 1024; # mb
      randomEncryption.enable = true;
    }];

  services.fstrim.enable = true;
}
