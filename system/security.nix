{ pkgs, ... }:
{
  services.pcscd.enable   = true;
  programs.ssh.startAgent = false;

  services.udev.packages = [ pkgs.yubikey-personalization ];

  security.pam.services.swaylock = {};
}
