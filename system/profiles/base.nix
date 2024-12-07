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
    enable   = true;
    hostKeys = [];
    banner   = ''
      Hello, leather bastard from ${config.networking.hostName}@${version}!
    '';
    settings.PasswordAuthentication = false;
  };
  environment.defaultPackages = lib.mkForce [];
  security.sudo.extraConfig = "Defaults lecture = never";

  users = {
    mutableUsers = false;
    users = let recoveryCfg = config.zoo.secrets.users.recovery; in {
      recovery = {
        inherit (recoveryCfg) uid description hashedPassword;
        isNormalUser = true;
        extraGroups  = [ "wheel" ];
        openssh.authorizedKeys.keys = [ recoveryCfg.authPublicKey ];
      };
      root.openssh.authorizedKeys.keys = [ config.zoo.secrets.deployment.authPublicKey ];
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
   font       = "iso01-12x22";
   keyMap     = "dvorak-programmer";
   earlySetup = true;
  };
  time.timeZone = "Europe/Moscow";
  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  environment.systemPackages = [ pkgs.test ];
  environment.pathsToLink    = [ "/share/zsh" ]; # for programs.zsh.enableCompletion

  documentation = {
    man.enable   = mkDefault false;
    doc.enable   = mkDefault false;
    info.enable  = mkDefault false;
    nixos.enable = mkDefault false;
  };
  services.journald.extraConfig = mkDefault "SystemMaxUse=100M";

  sss = let
    age = pkgs.rage + /bin/rage;
    pubKeys = {
      "asrock-x300" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwzqyKI0/H6h8yiZLCyUE914PZXXLHA9BhdOSwLUEEN";
      "mbp13"       = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC8h05MlXkvReetLrVjzPzzDVvcZEtlqM1cpS8TX9p8K";
      "helsinki1"   = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ4LkiDqNHY+OYYcd5OG1weezvYDNOnvTeatNYpH589J";
      "router"      = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOxNyBMfD0nhn1Hc/m9SVv84pT9Pj4NjrtZbljI0T4NA";
    };
    pubKey = pubKeys.${config.networking.hostName};
  in {
    enable = true;
    commands = {
      encrypt = "${age} -e -r '${pubKey}'";
      decrypt = "${age} -d -i /etc/ssh/ssh_host_ed25519_key";
    };
  };
}
