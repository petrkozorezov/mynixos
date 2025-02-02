{ config, pkgs, lib, ... }: let
  inherit (config.mynixos) secrets;
  b2auth = secrets.services.b2.keys.restic;
in {
  mynixos.backups = {
    enable = true;
    password = secrets.services.b2.resticPassword;
    s3repo = {
      keyID = b2auth.keyID;
      appKey = b2auth.appKey;
      # TODO get from terraform state
      endpoint = "s3:https://s3.eu-central-003.backblazeb2.com/petrkozorezov-backups/main";
    };
  };
}
