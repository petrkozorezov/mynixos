{ pkgs, config, self, lib, ... }: with lib; let
  hostname = config.networking.hostName;
  reformatDateTime = datetime:
    let s = from: count: builtins.substring from count datetime;
    in "${s 0 4}${s 4 2}${s 6 2}-${s 8 2}${s 10 2}${s 12 2}";
  version = "${reformatDateTime self.lastModifiedDate}-${self.shortRev or "dirty"}";
in {
  imports = [ ./nix.nix ];
  system.configurationRevision = version;
  system.nixos.label           = version;

  services.openssh = {
    enable                 = true;
    passwordAuthentication = false;
    hostKeys               = [];
    banner                 = ''
      Hello, leather bastard from ${config.networking.hostName}@${version}!
    '';
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

  documentation = {
    man.enable   = mkDefault false;
    doc.enable   = mkDefault false;
    info.enable  = mkDefault false;
    nixos.enable = mkDefault false;
  };
  services.journald.extraConfig = mkDefault "SystemMaxUse=100M";

  sss = let
    age = pkgs.rage + /bin/rage;
    pubKey = config.zoo.secrets.sshPubKeys.${config.networking.hostName};
  in {
    enable = true;
    commands = {
      encrypt = "${age} -e -r '${pubKey}'";
      decrypt = "${age} -d -i /etc/ssh/ssh_host_ed25519_key";
    };
  };
}
