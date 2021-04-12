{ config, lib, pkgs, modulesPath, ... }:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./ssd-970-pro.nix
    ];

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "sdhci_pci" "battery" ];
      kernelModules = [ "battery" ];
    };
    kernelModules = [ "kvm-intel" "iwlwifi" ];
    extraModulePackages = [ ];
    #blacklistedKernelModules      = [ "nouveau" ];
    loader = {
      efi.canTouchEfiVariables = true;
      #systemd-boot.consoleMode = "max";
    };
  };

  hardware = {
    enableAllFirmware         = true;
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
  };

  # backlight control
  programs.light.enable = true;

  hardware.enableRedistributableFirmware = true;

  hardware.bluetooth.enable        = true;
  # TODO move to an ather place with if
  hardware.pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
  services.blueman.enable          = true;

  # TODO
  # hardware.opengl.enable = true;
  # hardware.opengl.extraPackages = with pkgs; [
  #   intel-media-driver
  #   vaapiIntel
  #   vaapiVdpau
  #   libvdpau-va-gl
  # ];
}
