{ pkgs, ... }:
{
  programs = {
    git = {
      enable    = true;
      userEmail = "petr.kozorezov@gmail.com";
      userName  = "Petr Kozorezov";
      extraConfig = {
        push.default   = "current";
        pull.ff        = "only";
        core.quotePath = false;
      };
    };
    gh = {
      enable      = true;
      settings.gitProtocol = "ssh";
      # TODO
      #aliases = {};
    };
  };

  home.packages = with pkgs;
    [
      glow
      git-crypt
      gitAndTools.git-filter-repo
      lazygit
    ];
}
