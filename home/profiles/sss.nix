{ config, pkgs, ... }: {
  sss = let
    age        = pkgs.rage + /bin/rage;
    userZooCfg = config.zoo.secrets.users.${config.home.username};
  in {
    enable = true;
    path   = "/run/user/${toString userZooCfg.uid}/keys";
    group  = "users";
    commands = {
      encrypt = "${age} -e -r ${userZooCfg.mainSecret.pub   }";
      decrypt = "${age} -d -i ${userZooCfg.mainSecret.target}";
    };

    # # Example
    # hm.secrets."test" = {
    #  text      = "hello";
    #  dependent = [ "pipewire.service" ];
    # };
  };
}
