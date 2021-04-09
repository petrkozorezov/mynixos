# https://sandervanderburg.blogspot.com/2015/03/on-nixops-disnix-service-deployment-and.html
# https://nix.dev/tutorials/deploying-nixos-using-terraform.html
let
  location = "hel1";
  apiToken = (import ../secrets).zoo.secrets.others.hetzner.apiToken; # FIXME
in {
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

  resources = {
    # TODO fix crash and enable
    # hetznerCloudFloatingIPs.fip2 = {
    #   inherit apiToken location;
    # };
    hetznerCloudNetworks.network1 = {
      inherit apiToken;
      ipRange  = "192.168.0.0/16"; # must be wider than subnets
      subnets  = ["192.168.3.0/24"];
    };
  };

  # hostname -> hosttype
  router    = (import ./router.nix);
  helsinki1 = (import ./helsinki1.nix);
}
