## https://nixos.wiki/wiki/WireGuard
{ pkgs, config, ... }:
{
  imports = [ ../dns.nix ];
  networking =
    let
      hostName = config.networking.hostName;
      # localIf  = "ens10";
      extIf    = "ens3";
      vpnIf    = "wg0";
      vpnPort  = 51822;
    in {
      nat = {
        enable             = true;
        externalInterface  = extIf;
        internalInterfaces = [ vpnIf ];
      };
      firewall = {
        allowedUDPPorts = [ vpnPort ];
      };

      # vpn
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
