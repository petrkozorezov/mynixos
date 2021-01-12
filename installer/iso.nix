{ pkgs, config, ... }:
{
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];

  users = {
    mutableUsers = false;
    users.root.openssh.authorizedKeys.keys = [ config.zoo.secrets.users.petrkozorezov.authPublicKey ];
  };

  environment.etc = {
    # TODO move to the better place
    "installer/install.sh" = {
      source = ./install.sh;
      mode   = "0700";
    };

    "installer/configuration.nix" = {
      source = ./configuration.nix;
      mode   = "0660";
    };
  };
}
