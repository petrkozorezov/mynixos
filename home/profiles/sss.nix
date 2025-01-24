{ config, pkgs, ... }: {
  sss = let
    age     = pkgs.rage + /bin/rage;
    userCfg = config.mynixos.secrets.users.${config.home.username};
  in {
    enable = true;
    path   = "/run/user/${toString userCfg.uid}/keys";
    group  = "users";
    commands = {
      encrypt = "${age} -e -r ${userCfg.mainSecret.pub   }";
      decrypt = "${age} -d -i ${userCfg.mainSecret.target}";
    };

    # # Example
    # hm.secrets."test" = {
    #  text      = "hello";
    #  dependent = [ "pipewire.service" ];
    # };
  };
}
