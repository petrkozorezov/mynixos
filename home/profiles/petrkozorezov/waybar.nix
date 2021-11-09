{ ... }:
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
            format     = "{}";
            max-length = 50;
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

    style =
      ''
      * {
        border: none;
        border-radius: 0;
        font-family: Hack;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background: transparent;
        color: white;
      }

      #window {
        font-weight: bold;
      }

      #workspaces button {
        padding: 0 5px;
        background: transparent;
        color: white;
        border-top: 2px solid transparent;
      }

      #workspaces button.focused {
        color: #c9545d;
        border-top: 2px solid #c9545d;
      }

      #mode {
        background: #64727D;
        border-bottom: 3px solid white;
      }

      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #custom-spotify, #tray, #mode {
        padding: 0 3px;
        margin: 0 2px;
      }

      #clock {
        font-weight: bold;
      }

      #battery {
      }

      #battery icon {
        color: red;
      }

      #battery.charging {
      }

      @keyframes blink {
        to {
          background-color: #ffffff;
          color: black;
        }
      }

      #battery.warning:not(.charging) {
        color: white;
        animation-name: blink;
        animation-duration: 0.5s;
        animation-timing-function: linear;
        animation-iteration-count: infinite;
        animation-direction: alternate;
      }

      #cpu {
      }

      #memory {
      }

      #network {
      }

      #network.disconnected {
        background: #f53c3c;
      }

      #pulseaudio {
      }

      #pulseaudio.muted {
      }

      #custom-spotify {
        color: rgb(102, 220, 105);
      }

      #tray {
      }
      ''
    ;
  };
}
