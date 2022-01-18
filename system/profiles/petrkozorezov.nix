{ config, ... }: {
  # TODO move to flake
  users = {
    groups.plugdev = {};
    mutableUsers = false;
    users = let
      userCfg = config.zoo.secrets.users.petrkozorezov;
    in {
      petrkozorezov = {
        isNormalUser                = true;
        description                 = userCfg.description;
        extraGroups                 = [ "wheel" "audio" "video" "plugdev" "input" "wireshark" "vboxusers" "networkmanager" "docker" ];
        shell                       = userCfg.shell;
        hashedPassword              = userCfg.hashedPassword;
        openssh.authorizedKeys.keys = [ userCfg.authPublicKey ]; # deploy
      };
    };
  };
}
