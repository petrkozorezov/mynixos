{ pkgs, ... }: {
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
   font       = "iso01-12x22";
   keyMap     = "dvorak-programmer";
   earlySetup = true;
  };
  time.timeZone = "Europe/Moscow";
  programs.vim.defaultEditor = true;

  environment.systemPackages = [ pkgs.overlay-sys-test ];
  environment.pathsToLink    = [ "/share/zsh" ]; # for programs.zsh.enableCompletion

  services = {
    # timesyncd.enable = true;
    ntp.enable       = false;
  };
}
