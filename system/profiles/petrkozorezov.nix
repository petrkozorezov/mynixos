{ config, ... }: let
  user       = "petrkozorezov";
  userZooCfg  = config.zoo.secrets.users.${user};
  recoveryCfg = config.zoo.secrets.users.recovery;
in {
  # TODO move to flake
  users = {
    groups.plugdev = {};
    mutableUsers = false;
    users = {
      "${user}" = {
        inherit (userZooCfg) uid description shell hashedPassword;
        isNormalUser                = true;
        extraGroups                 = [ "wheel" "audio" "video" "plugdev" "input" "wireshark" "vboxusers" "networkmanager" "docker" ];
        openssh.authorizedKeys.keys = [ userZooCfg.authPublicKey ];
      };
      # TODO move to a better place
      recovery = {
        inherit (recoveryCfg) uid description hashedPassword;
        isNormalUser                = true;
        openssh.authorizedKeys.keys = [ recoveryCfg.authPublicKey ];
      };
    };
  };

  # main user secret to decrypt user specific secrets
  sss.secrets."${user}-main-secret" = {
    text   = userZooCfg.mainSecret.priv;
    target = userZooCfg.mainSecret.target;
    inherit user;
    dependent = [ "multi-user.target" ];
  };
}
