{ pkgs, ... }:
{
  programs.rofi = {
    enable      = true;
    package     = pkgs.rofi-wayland;
    terminal    = "alacritty";
    theme       = "theme";
    extraConfig =
      {
        matching = "fuzzy";
      };
  };
  home.packages = with pkgs; [ hack-font rofi-power-menu rofi-calc rofi-bluetooth ];
  xdg.configFile = {
    "rofi/theme.rasi".text =
      ''
        * {
           orange: #DB962F;
           gray  : #464952F5;
           white : #E8E8E8;

           transparency: "real";
           font: "Hack 14";
           background-color: #00000000;
        }

        window {
           border: 2px;
           border-radius: 10px;
           border-color    : @white;
           background-color: @gray;

           width: 1000px;
        }

        mainbox {
           margin: 20px;
           children: [inputbar, listview];
        }

        prompt {
           padding:6px 9px;
           text-color: @white;
        }

        entry {
           padding:6px 9px;
           blink: false;
           text-color: @white;
        }

        listview {
           padding: 6px 10px;
           text-color: @white;
           lines:       20;
        }

        element {
            text-color: @white;
        }

        element selected {
            //background-color: @orange;
            background-color: #E8E8E810;
            text-color: @white;
        }
      '';
  };
}

