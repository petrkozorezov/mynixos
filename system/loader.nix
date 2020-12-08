{ ... }:
{
  boot.loader = {
    systemd-boot.enable      = true;
    timeout                  = 1;
    efi.canTouchEfiVariables = true;
    #systemd-boot.consoleMode = "max";
  };
}
