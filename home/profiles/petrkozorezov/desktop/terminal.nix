{ pkgs, ... }:
{
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
        key_bindings = [
          { key = "Escape";                   mode="~Search"; chars = "\\x07";                         } # Ctrl-G
          { key = "G"     ; mods = "Control"; mode="~Search";                  action = "ReceiveChar"; } # Ctrl-G
          # { key = "F21"   ; mode="~Search"; chars = "\\x07"; } # Ctrl-R
          # { key = "F22"   ; mode="~Search"; chars = "\\x07"; } # Ctrl-Z
          # { key = "F23"   ; mode="~Search"; chars = "\\x07"; } # Ctrl-C
          # { key = "F24"   ; mode="~Search"; chars = "\\x07"; } # Ctrl-D
        ];
        bell = {
          color    = "#aaaaaa";
          duration = 100;
        };
        cursor.style.shape = "beam";
      };
  };
  home.packages = with pkgs; [ jetbrains-mono ];
  home.sessionVariables.TERMINAL = "alacritty";
}
