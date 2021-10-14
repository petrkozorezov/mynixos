{ pkgs, ... }: {
  services.udev.packages = [ pkgs.uhk-agent ];
}
