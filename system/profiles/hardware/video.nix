{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ vulkan-tools ];
  hardware.graphics = {
    enable        = true;
    enable32Bit   = true;
    extraPackages = with pkgs; [
      # https://discourse.ubuntu.com/t/enabling-accelerated-video-decoding-in-firefox-on-ubuntu-21-04/22081
      vaapiVdpau
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs; [ pkgsi686Linux.libva ];
  };
}
