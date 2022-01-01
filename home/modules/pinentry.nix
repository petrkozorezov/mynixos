{ pkgs, config, lib, ... }:
with lib; {
  options.programs.pinentry = {
    enable  = mkEnableOption "pinentry";
    package = mkOption {
      description = "pinentry package to use";
      type        = types.package;
      default     = pkgs.pinentry-curses;
    };
  };

  config = let
    cfg = config.programs.pinentry;
  in mkIf cfg.enable {
    home.packages = [ cfg.package ];
  };
}
