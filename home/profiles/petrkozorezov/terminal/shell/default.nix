# TODO
#  - carapace
#  - broot
#  - autin(?)
{ pkgs, deps, ... }: {
  imports = [
    deps.inputs.nix-index-database.hmModules.nix-index
    ./nushell.nix
    ./zsh.nix
    ./packages.nix
  ];

  home.packages = with pkgs; [
    du-dust # du
    duf     # df
    procs   # ps
    fd      # find
    ripgrep # grep
    tokei   # cloc
    bat     # cat
    jaq     # jq
    rsync
  ];

  programs.bat.enable = true;
  programs.direnv = {
    enable               = true;
    nix-direnv.enable    = true;
  };
  programs.zoxide.enable = true;
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol   = "[λ](bold red)";
      };
      erlang = { disabled = true; };
      elixir = { disabled = true; };
    };
  };
  programs.skim = rec {
    enable                 = true;
    defaultCommand         = "${pkgs.fd}/bin/fd";
    fileWidgetCommand      = "${defaultCommand} --type f";
    fileWidgetOptions      = [ "--preview='cat --color=always {}'" ];
    changeDirWidgetCommand = "${defaultCommand} --type d";
    changeDirWidgetOptions = [ "--preview='tree -L 1 -C {} | head -200'" ];
    historyWidgetOptions   = [];
  };
}

