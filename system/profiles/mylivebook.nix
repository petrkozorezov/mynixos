{ config, pkgs, deps, system, ... }: let
  user = "petrkozorezov";
  userCfg = config.users.users."${user}";
  secretsPath = "/run/user/${toString userCfg.uid}";
in {
  services.mylivebook = {
    inherit user;
    enable = true;
    settings = {
      ip                = "127.0.0.1";
      home              = "${toString userCfg.home}/livebook";
      dataPath          = "${toString userCfg.home}/livebook/data";
      passwordFile      = toString config.sss.secrets.livebook-passwd.target;
      secretKeyBaseFile = toString config.sss.secrets.livebook-secret-key-base.target;
    };
    openFirewall = false;
  };
  systemd.services.mylivebook.path = with pkgs; [
      git rebar3 gnumake zlib gnutar gzip gcc
      (deps.inputs.fenix.packages.${system}.latest.withComponents [
        "cargo"
        "rustc"
      ])
  ];
  sss.secrets.livebook-passwd = {
    inherit user;
    text      = config.zoo.secrets.livebook.passwd;
    target    = "${secretsPath}/livebook-passwd";
    dependent = [ "mylivebook.service" ];
  };
  sss.secrets.livebook-secret-key-base = {
    inherit user;
    text      = config.zoo.secrets.livebook.secretKeyBase;
    target    = "${secretsPath}/livebook-secret-key-base";
    dependent = [ "mylivebook.service" ];
  };
}
