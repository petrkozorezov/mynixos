## https://nixos.wiki/wiki/WireGuard
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

            privateKey = (builtins.getAttr hostName keys).priv;
            peers =
              let
                peersKeys = builtins.attrValues (builtins.removeAttrs keys [ hostName ]);
                peer = pub: addr:
                  {
                    publicKey  = pub;
                    allowedIPs = [ "${subnet_addr}.${addr}/32" ];
                  };
              in
                builtins.map (el: peer el.pub el.addr) peersKeys;
          };
        };
    };
}
