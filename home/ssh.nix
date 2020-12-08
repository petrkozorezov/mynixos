{ config, ... }:
{
  programs.ssh = {
    enable = true;
    matchBlocks =
      # for ordering use dag functions see
      # https://github.com/nix-community/home-manager/blob/cb17f1ede2fe777c1d879dc99c8d242a80985ff2/doc/release-notes/rl-2003.adoc
      {
        "kwin-us-east1-?.prod.kubient.net" = {
          user = "ubuntu";
        };
        "khub-us-east1-?.prod.kubient.net" = {
          user = "ubuntu";
        };
        "router" = {
          user = "root";
          port = 2222;
        };
      };
    forwardAgent = true;
    extraConfig =
      ''
          User ${config.home.username}
          AddKeysToAgent yes
      '';
  };
}
