{ pkgs, ... }:
let email = "petr.kozorezov@gmail.com"; in {
  programs = {
    git = {
      enable    = true;
      userEmail = email;
      userName  = "Petr Kozorezov";
      extraConfig = {
        push.default       = "current";
        pull.ff            = "only";
        core.quotePath     = false;
        init.defaultBranch = "master";
        fetch.prune        = true;
      };
      signing = {
        key           = email;
        signByDefault = true;
      };
    };
    gh = {
      enable = true;
      settings.gitProtocol = "ssh";
      extensions = with pkgs; [
        gh-dash # dashboard
        gh-poi  # branches sync
        gh-s    # search
      ];
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
