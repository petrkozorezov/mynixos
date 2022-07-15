{ config, ... }: {
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
}
