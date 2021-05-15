{ ... }:
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
            size = 13.0;
          };
        background_opacity = 0.99;
        colors = {
          primary = {
            background = "0x262626";
            foreground = "0xeaeaea";
          };
          normal = {
            black   = "0x000000";
            red     = "0xcc0403";
            green   = "0x19cb00";
            yellow  = "0xcecb00";
            blue    = "0x0d73cc";
            magenta = "0xcb1ed1";
            cyan    = "0x0dcdcd";
            white   = "0xdddddd";
          };
          bright = {
            black   = "0x767676";
            red     = "0xf2201f";
            green   = "0x23fd00";
            yellow  = "0xfffd00";
            blue    = "0x1a8fff";
            magenta = "0xfd28ff";
            cyan    = "0x14ffff";
            white   = "0xffffff";
          };
        };
        env = {
          TERM = "xterm-256color";
        };
        key_bindings = [
          { key = "Escape"; mode="~Search"; chars = "\\x07"; } # Ctrl-G
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
}
