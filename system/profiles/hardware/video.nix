{ pkgs, ... }:
{
  hardware.opengl = {
    enable          = true;
    driSupport      = true;
    driSupport32Bit = true;
    extraPackages   = with pkgs; [
      # https://discourse.ubuntu.com/t/enabling-accelerated-video-decoding-in-firefox-on-ubuntu-21-04/22081
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
}
