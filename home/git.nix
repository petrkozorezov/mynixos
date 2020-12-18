{ pkgs, ... }:
{
  programs = {
    git = {
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
    gh = {
      enable      = true;
      gitProtocol = "ssh";
      # TODO
      #aliases = {};
    };
  };


  home.packages = with pkgs;
    [
      glow
      git-crypt
      gitAndTools.git-filter-repo
    ];
}
