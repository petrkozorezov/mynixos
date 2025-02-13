{
  programs.foot = {
    enable = true;
    # man foot.ini
    settings = {
      main.term = "xterm-256color";
      mouse.hide-when-typing = "yes";
      scrollback.lines = 100000;
      cursor.style = "beam";
      bell.visual = "yes";
    };
  };
  home.sessionVariables.TERMINAL = "foot";
}
