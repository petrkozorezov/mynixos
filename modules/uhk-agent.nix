{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.uhk-agent;
  package = pkgs.uhk-agent;
in
{
  options = {
    programs.uhk-agent = {
      enable = mkEnableOption "uhk-agent";
    };
    # TODO package
  };
  config = mkIf cfg.enable {
    environment.systemPackages = [ package ];
    services.udev.packages     = [ package ];
  };
}
