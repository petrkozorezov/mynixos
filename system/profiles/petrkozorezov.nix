{ config, ... }: let
  user       = "petrkozorezov";
  userZooCfg = config.zoo.secrets.users.${user};
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
        openssh.authorizedKeys.keys = [ userZooCfg.authPublicKey ]; # deploy
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
