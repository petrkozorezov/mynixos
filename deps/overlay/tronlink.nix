args@{ pkgs, lib, deps, ... }: let
  pname   = "tronlink";
  version = "1.5.1";
  addonId = "{5799d9b6-8343-4c26-9ab6-5d2ad39884ce}";
in
  deps.inputs.firefox-addons.lib.buildFirefoxAddon {
    inherit pname version addonId;
    derivationArgs = {
      src = ./tronlink.xpi;
      meta.platform = lib.platforms.all;
    };
  } args
