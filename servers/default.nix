{
  network = {
    description    = "zoo main network";
    enableRollback = true;
  };

  defaults = {
    imports = [
      ./modules
    ];
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ../secrets/ssh.key.pub) ];
    deployment.provisionSSHKey = false; # TODO check it
  };

  # hostname -> hosttype
  router    = (import ./router.nix);
  # helsinki1 = (import ./dc.nix);
}
