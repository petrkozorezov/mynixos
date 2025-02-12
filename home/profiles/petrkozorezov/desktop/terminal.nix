{ pkgs, ... }: {
  programs.alacritty = {
    enable = true;
    settings =
      {
        scrolling =
          {
            history    = 10000;
            multiplier = 30;
          };
        font =
          {
            normal.family = "JetBrains Mono";
            size = 10.0;
          };
        window.opacity = 0.95;
        colors = {
          primary = {
            background = "#272822";
            foreground = "#f8f8f2";
          };
          cursor = {
            text       = "#272822";
            cursor     = "#f8f8f2";
          };
          normal = {
            black      = "#272822";
            red        = "#f92672";
            green      = "#a6e22e";
            yellow     = "#f4bf75";
            blue       = "#66d9ef";
            magenta    = "#ae81ff";
            cyan       = "#a1efe4";
            white      = "#f8f8f2";
          };
          bright = {
            black      = "#75715e"; # FIXME not readable (see echo '{"a":null}' | jq .)
            red        = "#f92672";
            green      = "#a6e22e";
            yellow     = "#f4bf75";
            blue       = "#66d9ef";
            magenta    = "#ae81ff";
            cyan       = "#a1efe4";
            white      = "#f9f8f5";
          };
        };
        env = {
          TERM = "xterm-256color";
        };
        keyboard.bindings = [
          { key = "Escape";                   mode="~Search"; chars = "\\u0007";                       } # Ctrl-G
          { key = "G"     ; mods = "Control"; mode="~Search";                  action = "ReceiveChar"; } # Ctrl-G
        ];
        bell = {
          color    = "#aaaaaa";
          duration = 100;
        };
        cursor.style.shape = "beam";
      };
  };

  programs.foot = {
    enable = true;
    # man foot.ini
    settings = {
      main = {
        term = "xterm-256color";
        # font = "JetBrains Mono:size=10";
        dpi-aware = "yes";
      };
      mouse = {
        hide-when-typing = "yes";
      };
      scrollback = {
        lines=100000;
      };
      colors = {
        alpha      = 0.95;
        background = "272822";
        foreground = "f8f8f2";
        regular0   = "272822";
        regular1   = "f92672";
        regular2   = "a6e22e";
        regular3   = "f4bf75";
        regular4   = "66d9ef";
        regular5   = "ae81ff";
        regular6   = "a1efe4";
        regular7   = "f8f8f2";
        bright0    = "75715e";
        bright1    = "f92672";
        bright2    = "a6e22e";
        bright3    = "f4bf75";
        bright4    = "66d9ef";
        bright5    = "ae81ff";
        bright6    = "a1efe4";
        bright7    = "f9f8f5";
      };
      cursor.style = "beam";
      bell.visual = "yes";
      text-bindings = {
        "\x07" = "Escape";
        # TODO Ctrl+G
      };
    };
  };

  home.packages = with pkgs; [ jetbrains-mono ];
  home.sessionVariables.TERMINAL = "foot";
}
