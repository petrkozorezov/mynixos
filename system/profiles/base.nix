{ pkgs, config, inputs, lib, ... }: let
  hostname = config.networking.hostName;
in {
  system.configurationRevision = "${inputs.self.lastModifiedDate}-${inputs.self.shortRev or "dirty"}";

  services.openssh = {
    enable                 = true;
    passwordAuthentication = false;
    hostKeys               = [];
  };
  environment.etc = let
    key = config.zoo.secrets.keys.sshd.${hostname};
  in {
    "ssh/ssh_host_key" = {
      mode   = "600";
      source = key.priv;
    };
    "ssh/ssh_host_key.pub" = {
      mode   = "0644";
      source = key.pub;
    };
  };
  environment.defaultPackages = lib.mkForce [];
  users.users.root.openssh.authorizedKeys.keys = [ config.zoo.secrets.deployment.authPublicKey ];
  security.sudo.extraConfig = "Defaults lecture = never";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
   font       = "iso01-12x22";
   keyMap     = "dvorak-programmer";
   earlySetup = true;
  };
  time.timeZone = "Europe/Moscow";
  programs.vim.defaultEditor = true;

  environment.systemPackages = [ pkgs.test ];
  environment.pathsToLink    = [ "/share/zsh" ]; # for programs.zsh.enableCompletion

  services = {
    # timesyncd.enable = true;
    # ntp.enable       = false;
  };
}
