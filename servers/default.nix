# https://sandervanderburg.blogspot.com/2015/03/on-nixops-disnix-service-deployment-and.html
{
  network = {
    description    = "zoo main network";
    enableRollback = true;
  };

  defaults = { config, ... }: {
    imports = [
      ../secrets
      ./modules
    ];
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ config.zoo.secrets.users.petrkozorezov.authPublicKey ]; # FIXME default user
    deployment.provisionSSHKey = false; # TODO check it
  };

  # hostname -> hosttype
  router    = (import ./router.nix);
  # helsinki1 = (import ./dc.nix);
}
