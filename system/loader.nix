{ ... }:
{
  boot.loader = {
    systemd-boot.enable = true;
    timeout             = 1;
  };
}
