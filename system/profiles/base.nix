{ pkgs, config, inputs, lib, ... }: let
  hostname = config.networking.hostName;
  reformatDateTime = datetime:
    let s = from: count: builtins.substring from count datetime;
    in "${s 0 4}.${s 4 2}.${s 6 2}-${s 8 2}:${s 10 2}:${s 12 2}";
in {
  system.configurationRevision = "${reformatDateTime inputs.self.lastModifiedDate}-${inputs.self.shortRev or "dirty"}";

  services.openssh = {
    enable                 = true;
    passwordAuthentication = false;
    hostKeys               = [];
    banner                 = ''
      Hello, leather bastard from ${config.networking.hostName} ${config.system.configurationRevision}!
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

  sss = let
    age = pkgs.rage + /bin/rage;
    pubKeys = {
      "asrock-x300" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJwzqyKI0/H6h8yiZLCyUE914PZXXLHA9BhdOSwLUEEN";
      "mbp13"       = "ssh-ed25519 TODO";
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
