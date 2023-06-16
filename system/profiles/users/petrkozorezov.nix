{ config, ... }: let
  user    = "petrkozorezov";
  userCfg = config.zoo.secrets.users.${user};
in {
  # TODO move to flake
  users = {
    groups.plugdev = {};
    mutableUsers = false;
    users = {
      "${user}" = {
        inherit (userCfg) uid description shell hashedPassword;
        isNormalUser                = true;
        extraGroups                 = [ "wheel" "audio" "video" "plugdev" "input" "wireshark" "vboxusers" "networkmanager" "docker" ];
        openssh.authorizedKeys.keys = [ userCfg.authPublicKey ];
      };
    };
  };

  nix.settings.trusted-users = [ user ];

  # main user secret to decrypt user specific secrets
  sss.secrets."${user}-main-secret" = {
    text   = userCfg.mainSecret.priv;
    target = userCfg.mainSecret.target;
    inherit user;
    dependent = [ "multi-user.target" ];
  };
}
