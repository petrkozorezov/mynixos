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
    [
      { device = "/dev/disk/by-uuid/66be6355-c124-4035-928a-ce2e904893f5"; }
    ];

  services.fstrim.enable = true;
}
