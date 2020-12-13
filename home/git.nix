{ pkgs, ... }:
{
  programs.git = {
    enable    = true;
    userEmail = "petr.kozorezov@gmail.com";
    userName  = "Petr Kozorezov";
    signing   = {
      key           = "EF2A246DDE509B0C";
      signByDefault = true;
    };
    extraConfig = {
      push.default = "current";
      pull.ff      = "only";
    };
  };

  home.packages = with pkgs;
    [
      gitAndTools.hub
      gitAndTools.gh
      glow
      git-crypt
      gitAndTools.git-filter-repo
    ];
}
