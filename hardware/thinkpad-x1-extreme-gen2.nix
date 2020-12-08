{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "sdhci_pci" "battery" ];
      kernelModules = [ "battery" ];
    };
    kernelModules = [ "kvm-intel" "iwlwifi" ];
    extraModulePackages = [ ];
    #blacklistedKernelModules      = [ "nouveau" ];
  };

  fileSystems = {
    "/" =
      { device = "/dev/disk/by-uuid/e919fa4c-439e-455c-9529-f284a30434c0";
        fsType = "ext4";
      };

    "/boot" =
      { device = "/dev/disk/by-uuid/2F08-52CD";
        fsType = "vfat";
      };
  };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/66be6355-c124-4035-928a-ce2e904893f5"; }
    ];

  hardware = {
    enableAllFirmware = true;
    cpu.intel.updateMicrocode = true;
  };

  nix.maxJobs = lib.mkDefault 12;
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  services = {
    throttled.enable   = true;
    undervolt = {
      enable         = true;
      coreOffset     = -150;
      gpuOffset      = -150;
      uncoreOffset   = -150;
      analogioOffset = -100;
    };
    logind = {
      extraConfig =
        ''
          IdleAction=ingore # TODO suspend
          #HandlePowerKey=ignore
        '';
       lidSwitch              = "suspend";
       lidSwitchExternalPower = "suspend";
       lidSwitchDocked        = "suspend";
    };
  };

  # backlight control
  programs.light.enable = true;
}
