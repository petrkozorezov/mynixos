## https://nixos.wiki/wiki/WireGuard

# [Interface]
# PrivateKey = <privkey-client>
# Address = <peer-ip>

# [Peer]
# PublicKey = <pubkey-server>
# Endpoint = <server-ip:port>
# AllowedIPs = 0.0.0.0/0 # change it to route only part of traffic
# PersistentKeepAlive = 25

## How to add to phone
# $ qrencode -t ansiutf8 < wg.conf

## How to add to network manager
# $ nmcli connection import type wireguard file wg.conf

{ modulesPath, pkgs, config, lib, ... }:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    #../terraform.state.nix
  ];
  # TODO move to hardware conf
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.kernelModules = [ "nvme" ];
  fileSystems."/" = { device = "/dev/sda3"; fsType = "ext4"; };

  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys =
    [ config.zoo.secrets.users.petrkozorezov.authPublicKey ]; # FIXME default user

  networking =
    let
      hostName = "helsinki1";
      localIf  = "ens10";
      extIf    = "ens3";
      vpnIf    = "wg0";
      vpnPort  = 51822;
    in {
      hostName = hostName;
      nat = {
        enable             = true;
        externalInterface  = extIf;
        internalInterfaces = [ vpnIf ];
      };
      firewall = {
        allowedUDPPorts = [ vpnPort ];
      };

      wireguard.interfaces =
        let
          subnet_addr = "192.168.4";
          subnet_mask = "/24";
          subnet = ip: "${subnet_addr}.${ip}${subnet_mask}";
          keys = config.zoo.secrets.vpn;
        in {
          "${vpnIf}" = {
            ips = [ "${subnet_addr}.1${subnet_mask}" ];
            listenPort = vpnPort;

            postSetup = ''
              ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s ${subnet "0"} -o ${extIf} -j MASQUERADE
            '';
            postShutdown = ''
              ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s ${subnet "0"} -o ${extIf} -j MASQUERADE
            '';

            privateKey = keys."${hostName}".priv;

            peers =
              # TODO generate from config.zoo.secrets.vpn
              let peerIps = ip: [ "${subnet_addr}.${ip}/32" ]; in
              [
                {
                  publicKey = keys.galaxy-s20u.pub;
                  allowedIPs = peerIps "2";
                }
                {
                  publicKey = keys.router.pub;
                  allowedIPs = peerIps "3";
                }
                {
                  publicKey = keys.asrock-x300.pub;
                  allowedIPs = peerIps "4";
                }
              ];
          };
        };
    };
}
