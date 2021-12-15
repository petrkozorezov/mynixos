{ config, options, lib, pkgs, modulesPath, slib, ... }:
with lib;
let
  helpers = import (modulesPath + "/services/networking/helpers.nix") { inherit config lib; };
  cfg     = config.networking.forwarding;
in {
  options.networking.forwarding = {
    enable   = mkEnableOption "enable forwarding";
    firewall = {
      enable = mkOption {
        type         = types.bool;
        default      = true;
        description  = "refuse any forwarding packets by default";
      };
      allow = mkOption { type = types.listOf slib.firewall.types.filter; default = [ ]; };
      # TODO deny/reject/refuse
    };
  };

  config =
    (mkIf cfg.enable (mkMerge [
      {
        boot.kernel.sysctl = {
          "net.ipv4.conf.all.forwarding"     = true;
          "net.ipv4.conf.default.forwarding" = true;
        };
      }
      (mkIf cfg.firewall.enable {
        networking.firewall = let
            formatFilter  = filter: (slib.firewall.treeToString (slib.firewall.format.filter filter));
            addAllowRule  = filter: "ip46tables -A nixos-fw-fwd ${formatFilter filter} -j nixos-fw-accept"; # TODO ipv6 support
            addAllowRules = builtins.concatStringsSep "\n" (map addAllowRule cfg.firewall.allow);
          in {
          # TODO reload
          extraCommands = ''
            ${helpers}
            ip46tables -N nixos-fw-fwd
            ${addAllowRules}
            ip46tables -A nixos-fw-fwd -j nixos-fw-refuse
            ip46tables -A FORWARD -j nixos-fw-fwd
          '';
          extraStopCommands =  ''
            ${helpers}
            ip46tables -D FORWARD -j nixos-fw-fwd 2>/dev/null || true
          '';
        };
      })
    ]));
}
