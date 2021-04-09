{ pkgs, resources, config, lib, ... }:
{
  deployment = {
    targetEnv    = "hetznercloud";
    hetznerCloud = {
      apiToken    = config.zoo.secrets.others.hetzner.apiToken;
      location    = "hel1";
      serverType  = "cx11";
      ipAddresses = [ "fip2" ];
      serverNetworks = [
        {
          network   = resources.hetznerCloudNetworks.network1;
          privateIP = "192.168.3.1";
        }
      ];
    };
  };

  networking = {
    nat = {
      enable             = true;
      externalInterface  = "wg0";
      internalInterfaces = [ "ens3" ];
    };

    # TODO remove copy/paste
    wireguard.interfaces = let
      vpnCfg    = config.zoo.secrets.vpn;
      vpnSubnet = "192.168.4";
    in {
      wg0 = {
        ips        = [ "${vpnSubnet}.1/24" ];
        listenPort = 31337;
        privateKey = vpnCfg.helsinki1.priv;
        peers = [
          {
            publicKey = vpnCfg.router.priv;
            allowedIPs = [ "${vpnSubnet}.2/32" ];
          }
          {
            publicKey = vpnCfg.mbp13.priv;
            allowedIPs = [ "${vpnSubnet}.3/32" ];
          }
          {
            publicKey = vpnCfg.galaxyS20.priv;
            allowedIPs = [ "${vpnSubnet}.4/32" ];
          }
        ];
      };
    };
  };

}
