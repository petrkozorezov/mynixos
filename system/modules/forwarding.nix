{ config, options, lib, pkgs, modulesPath, slib, ... }:
with lib;
with builtins;
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
      allow = mkOption { type = types.listOf slib.firewall.types.spec; default = [ ]; };
      # TODO deny/reject/refuse
    };
  };

  config = let
    fwdChain    = "nixos-fw-fwd";
    refuseChain = "DROP";
    acceptChain = "ACCEPT";
    fwCmd       = name: cmd: "ip46tables ${slib.firewall.command name cmd}";
    ignoreResult = "2> /dev/null || true";
  in
    (mkIf cfg.enable (mkMerge [
      {
        boot.kernel.sysctl = mkForce {
          "net.ipv4.conf.all.forwarding"     = mkOverride 99 true;
          "net.ipv4.conf.default.forwarding" = mkOverride 99 true;
        };
      }
      (mkIf cfg.firewall.enable (mkMerge [{
        networking.firewall = let
            addAllowRule = spec:
              fwCmd "insert-rule" { chain = fwdChain; spec = spec; target = acceptChain; }; # TODO ipv6 support
            addAllowRules = concatStringsSep "\n" (map addAllowRule cfg.firewall.allow);
            cleanup = ''
              # cleanup
              ${fwCmd "delete-rules"  { chain  =   "FORWARD" ; target = fwdChain; }} ${ignoreResult}
              ${fwCmd "flush-chain"   { chain  =   fwdChain  ;                    }} ${ignoreResult}
              ${fwCmd "delete-chains" { chains = [ fwdChain ];                    }} ${ignoreResult}
            '';
          in {
          # TODO reload
          extraCommands = ''
            # networking.forwarding.firewall
            ${cleanup}

            # setup
            ${fwCmd "new-chain"   { chain = fwdChain ; }}
            ${fwCmd "append-rule" { chain = fwdChain ; target = refuseChain; }} # refuse by default
            ${addAllowRules}

            # enable
            ${fwCmd "append-rule" { chain = "FORWARD"; target = fwdChain; }}
          '';

          extraStopCommands =  ''
            # networking.forwarding.firewall
            ${cleanup}
          '';
        };
      }
      (mkIf config.networking.nat.enable {
        networking.firewall = let
          natCfg = config.networking.nat;
          output = { interface = natCfg.externalInterface; };
          inputs = map (input: { interface = input; }) natCfg.internalInterfaces;
          outputSpecs = map (input: { from = input ; to = output; }) inputs;
          inputSpecs  = map (input: { from = output; to = input ; match = { states = [ "ESTABLISHED" "RELATED" ]; }; }) inputs;
        in {
          # TODO internalIPs, externalIP, ipv6, forwardPorts
          extraCommands = ''
            # networking.firewall nat
            ${concatStringsSep "\n" (map (outputSpec: fwCmd "insert-rule" { chain = fwdChain; spec = outputSpec; target = acceptChain; }) outputSpecs)}
            ${concatStringsSep "\n" (map ( inputSpec: fwCmd "insert-rule" { chain = fwdChain; spec =  inputSpec; target = acceptChain; })  inputSpecs)}
          '';
        };
      })]))
    ]));
}
