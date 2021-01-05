{
  router = { ... }: {
    imports =
      [
        ../hardware/router.nix
      ];

    nixpkgs = (import ../nixpkgs.nix);

    deployment = {
      targetHost      = "192.168.1.200";
      provisionSSHKey = false;
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = false;
    };

    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ (builtins.readFile ../secrets/ssh.key.pub) ];

    networking = {
      hostName = "router";
      firewall.allowedTCPPorts = [
        80  # HTTP
        443 # HTTPs
      ];
      nat = {
        # enable = true;
        # enableIPv6 = true;
      };
    };

    # wifi setup https://habr.com/ru/post/315960/
    # wifi security https://habr.com/ru/post/224955/
    # WPA2-PSK-CCMP


    # uplink = "enp3s0"; # eth1
    services.dnsmasq = {
      # enable = true;
      servers = [ "8.8.8.8" ]; # TODO
      extraConfig =
        ''
          #
          # DHCP
          #
          #interface=eth2
          listen-address=::1,127.0.0.1,10.1.1.1
          dhcp-range=10.1.1.100,10.1.1.200,12h

          dhcp-host=00:00:00:00:00:00, router, 10.0.0.1 # TODO
          # ...

          # all options here https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
          dhcp-option=1,255.255.255.0   # mask
          dhcp-option=2,10800           # lease time
          dhcp-option=3,10.1.1.1        # default gateway
          dhcp-option,6,10.1.1.1        # dns server
          #dhcp-option=42,10.0.0.1       # TODO ntp
          #dhcp-boot=pxelinux.0,10.0.0.1 # TODO netboot

          dhcp-leasefile=/var/log/dnsmasq/dnsmasq.leases

          dhcp-authoritative
          log-dhcp

          #
          # DNS
          #
          #domain=mydomain.com
          no-hosts
        '';
    };
    # TODO add to resolv.conf 'nameserver 127.0.0.1'


    # Enable nginx service
    services.nginx = {
      enable = true;
    };
  };
}
