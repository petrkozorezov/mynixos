{ pkgs, config, lib, ... }:
let
  cfg     = config.mynixos.router;
  localIp = "${cfg.local.net}.${cfg.local.ip}"; # TODO remove copy/paste
in lib.mkIf cfg.enable {
  networking = {
    firewall = {
      allowedTCPPorts = [ 53 ];
      allowedUDPPorts = [ 53 67 ];
    };
    nameservers = [ "127.0.0.1" ]; # TODO mkForce
  };

  services.dnsmasq = {
    enable      = true;
    extraConfig =
      ''
        #
        # DNS
        #
        interface=${cfg.local.bridge.interface}
        #bind-dynamic
        local=/${cfg.domain}/
        domain=${cfg.domain}
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
        no-dhcp-interface=${cfg.uplink.interface}
        dhcp-range=${cfg.local.net}.100,${cfg.local.net}.200,3h # TODO configure

        address=/${cfg.hostname}/${localIp}
        address=/${cfg.hostname}.${cfg.domain}/${localIp} # FIXME (how?)
        # ...

        # all options here https://www.iana.org/assignments/bootp-dhcp-parameters/bootp-dhcp-parameters.xhtml
        dhcp-option=1,255.255.255.0     # mask
        dhcp-option=2,10800             # lease time (TODO should be same as in dhcp-range?)
        dhcp-option=3,${localIp}        # default gateway
        dhcp-option=6,${localIp}        # dns server
        #dhcp-option=42,${localIp}       # TODO ntp
        #dhcp-boot=pxelinux.0,${localIp} # TODO netboot

        dhcp-authoritative
        #log-dhcp
      ''
      +
      (let
        hostToString = { name, mac, ip }:
          "dhcp-host=${mac},${name},${cfg.local.net}.${ip}\n";
      in
        lib.strings.concatStrings (map hostToString (lib.attrValues cfg.local.hosts))
      );
  };
}
