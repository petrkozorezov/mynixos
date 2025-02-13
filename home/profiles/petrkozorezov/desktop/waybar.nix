{
  programs.waybar = {
    enable = true;
    settings = [{
      layer    = "top";
      position = "top";
      height   = 24;

      # output = [];
      modules-left   = ["sway/language" "sway/workspaces" "sway/mode"];
      modules-center = ["sway/window"];
      modules-right  = ["pulseaudio" "network" "cpu" "memory" "battery" "tray" "clock"];

      modules = {
        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "00"      = "";
            "01"      = "";
            "02"      = "";
            "05"      = "";
            "06"      = "";
            "07"      = "λ";
            "08"      = "";
            "09"      = "";
            "10"      = "♫";
            "urgent"  = "";
            "focused" = "";
            "default" = "";
          };
        };
        "sway/mode" = {
          format     =  " {}";
          max-length = 50;
        };
        "sway/language" = {
          format          = "{short}";
          tooltip-format  = "{long}";
          max-length      = 5;
          on-click        = "swaymsg 'input type:keyboard xkb_switch_layout next'";
        };
        "tray" = {
          # icon-size = 21;
          spacing = 10;
        };
        "clock" = {
          format-alt = "{:%Y-%m-%d}";
        };
        "cpu" = {
          format = "{usage}%";
        };
        "memory" = {
          format = "{}%";
        };
        "battery" = {
          bat = "BAT0";
          states = {
            # good = 95;
            warning  = 30;
            critical = 15;
          };
          format = "{capacity}% {icon}";
          # format-good = ""; # An empty format will hide the module
          # format-full = "";
          format-icons = ["" "" "" "" ""];
        };
        "network" = {
          format-wifi         = "{essid} ({signalStrength}%) ";
          format-ethernet     = "{ifname} ";
          format-disconnected = "nolink ⚠";
        };
        "pulseaudio" = {
          # scroll-step = 1;
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-muted = "";
          format-icons = {
            headphones = "";
            handsfree  = "";
            headset    = "";
            phone      = "";
            portable   = "";
            car        = "";
            default    = ["" ""];
          };
          on-click = "pavucontrol";
        };
      };
    }];
  };
}
