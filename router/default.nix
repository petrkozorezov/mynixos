{
  network = {
    description    = "zoo main network";
    enableRollback = true;
  };

  defaults = {
    imports = [ ];
  };

  router = { pkgs, lib, ... }:
  let
    uplinkIf   = "enp3s0";
    uplinkIp   = "192.168.1.200"; # FIXME
    localIf    = "enp4s0";
    localNet   = "192.168.2";
    localIp    = "${localNet}.1";
    localName  = "router-new";
    localMac   = "00:e0:b4:1d:95:69";
    authKey    = (builtins.readFile ../secrets/ssh.key.pub);
    dnsServers = [ "1.1.1.1" "8.8.8.8" ];
    domain     = "zoo";
    localHosts = {
      mbp = {
        mac     = "ac:87:a3:0c:83:96";
        address = "${localNet}.50";
      };
    };
  in {
    imports =
      [
        ../hardware/router.nix
      ];

    nixpkgs = (import ../nixpkgs.nix);

    deployment = {
      targetHost      = uplinkIp;
      provisionSSHKey = false; # TODO check it
    };

    # Use the systemd-boot EFI boot loader.
    boot.loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = false;
    };

    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [ authKey ];

    networking = {
      hostName = "${localName}";
      useDHCP  = false;

      interfaces = {
        "${uplinkIf}" = {
          useDHCP = true;
        };
        "${localIf}" = {
          useDHCP = false;
          ipv4.addresses =
            [ {
              address      = localIp;
              prefixLength = 24;
            } ];
        };
      };

      firewall = {
        enable = true;
        allowedTCPPorts = [ 53 ];
        allowedUDPPorts = [ 53 67 ];
      };

      nat = {
        enable            = true;
        # enableIPv6 = true;
        externalInterface  = uplinkIf;
        internalInterfaces = [ localIf ];
      };

      nameservers = [ "127.0.0.1" ];
      # nameservers = dnsServers;
    };

    # services.hostapd = {
    #   enable        = true;
    #   wpaPassphrase = "testpassword";
    #   interface     = "wlp2s0b1";
    #   ssid          = "Petrovi4New";
    #   channel       = 1;
    #   # countryCode   = "RU";
    #   extraConfig   =
    #     ''
    #       ieee80211n=1
    #       wpa_key_mgmt=WPA-PSK
    #       rsn_pairwise=CCMP
    #     '';
    # };

    # nixos networking https://nixos.wiki/wiki/Networking
    # wifi setup https://habr.com/ru/post/315960/
    # wifi security https://habr.com/ru/post/224955/
    # WPA2-PSK-CCMP

    services.dnsmasq = {
      enable  = true;
      # servers = dnsServers;
      extraConfig =
        ''
          #
          # DNS
          #
          listen-address=::1,127.0.0.1,${localIp}
          local=/${domain}/
          domain=${domain}
          no-hosts

          # dnssec
          conf-file=${pkgs.dnsmasq}/share/dnsmasq/trust-anchors.conf
          dnssec

          # do not send to uplink local data
          bogus-priv
          domain-needed

          #log-queries

          #
          # DHCP
          #
          interface=${localIf}
          bind-interfaces
          dhcp-range=${localNet}.100,${localNet}.200,3h

          address=/${localName}/${localIp}
          address=/${localName}.${domain}/${localIp} # FIXME (how?)
          # ...

          # all options here https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
          dhcp-option=1,255.255.255.0     # mask
          dhcp-option=2,10800             # lease time
          dhcp-option=3,${localIp}        # default gateway
          dhcp-option=6,${localIp}        # dns server
          #dhcp-option=42,${localIp}       # TODO ntp
          #dhcp-boot=pxelinux.0,${localIp} # TODO netboot

          dhcp-authoritative
          #log-dhcp

        ''
        +
        (lib.strings.concatStrings
          (lib.attrsets.mapAttrsToList (name:{ mac, address }:
            "dhcp-host=${mac},${name},${address}")
            localHosts));
    };

    # dhcp-host=,mbp13,${localNet}.50

    # services.home-assistant = {
    #   enable = true;
    #   package = pkgs.home-assistant.override {
    #     extraPackages = ps: with ps; [ colorlog ];
    #   };
    #   port = 8080;
    #   openFirewall = true;
    # };
  };
}

# sudo /nix/store/riks8dkavddh117fzb4hbfidpqmq9n4c-dnsmasq-2.82/bin/dnsmasq -d -k --enable-dbus --user=dnsmasq -C /nix/store/553hn9lp0m06f3wrcblqbkrbx8fpld5b-dnsmasq.conf
