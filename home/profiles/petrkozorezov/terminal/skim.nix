{ pkgs, ... }: {
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
