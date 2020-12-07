{ config, lib, pkgs, ... }:

let
  mod      = "Mod4";
  terminal = "alacritty";
  w_term_1 = "";
  w_term_2 = " ";
  w_web    = "";
  w_dev    = "λ";
  w_msg    = "Msg";
  w_mon    = "";
  w_pass   = "";
  sock     = "I3SOCK";
  # sock     = "SWAYSOCK";
  ob       = "xob";
  ob_file  = "\$${sock}.${ob}";
in {
  xsession.scriptPath = ".hm-xsession"; # Ref: https://discourse.nixos.org/t/opening-i3-from-home-manager-automatically/4849/8

  xsession.enable = true;
  home.packages = with pkgs; [
    #networkmanager_dmenu
    rofi                # unstable.wofi # launcher (wofi has a shit-like fuzzy search)
    networkmanager_vpnc
    networkmanager_l2tp
    networkmanagerapplet
    pavucontrol

    ## i3
    xob
    xorg.xev
  ];

  # wayland.windowManager.sway = {
  #   enable = true;
  #   extraSessionCommands =
  #     ''
  #       export SDL_VIDEODRIVER=wayland
  #       # needs qt5.qtwayland in systemPackages
  #       export QT_QPA_PLATFORM=wayland
  #       export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
  #       # Fix for some Java AWT applications (e.g. Android Studio),
  #       # use this if they aren't displayed properly:
  #       export _JAVA_AWT_WM_NONREPARENTING=1
  #     '';
  # };

  xsession.windowManager.i3 = {
    enable = true;
    config = rec {
      modifier = mod;
      fonts = ["Hack 10"];

      keybindings = {};

      # bars = [
      #   {
      #     position = "bottom";
      #     statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ${./i3status-rust.toml}";
      #   }
      # ];

      # 16 29 43 57 65
      keycodebindings = let
        workspaces = mod_: action: {
          "${mod_}+43" = "${action} workspace ${w_term_1}";
          "${mod_}+29" = "${action} workspace ${w_term_2}";
          "${mod_}+30" = "${action} workspace ${w_web}"   ;
          "${mod_}+32" = "${action} workspace ${w_dev}"   ;
          "${mod_}+33" = "${action} workspace ${w_msg}"   ;
          "${mod_}+34" = "${action} workspace ${w_mon}"   ;
          "${mod_}+35" = "${action} workspace ${w_pass}"  ;
        };
        arrows = mod_: action: {
          "${mod_}+44" = "${action} left";
          "$mod_}+45" = "${action} down";
          "${mod_}+31" = "${action} up";
          "${mod_}+46" = "${action} right";
        };
      in
        workspaces "${mod}"       ""      //
        workspaces "Shift+${mod}" "move"  //
        arrows     "${mod}"       "focus" //
        arrows     "Shift+${mod}" "move"  //
      {
        "Alt+Shift+22"    = "exec loginctl lock-sessionx";
        "${mod}+40"       = "exec rofi -show combi";
        "${mod}+Shift+40" = "exec rofi -show ssh";
        "${mod}+36"       = "exec ${terminal}";

        "${mod}+Shift+26" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";
        "${mod}+Shift+24" = "kill";
        "${mod}+Shift+25" = "restart";
        "${mod}+Shift+38" = "reload";

        "${mod}+25" = "layout tabbed";
        "${mod}+26" = "layout toggle split";
        "${mod}+27" = "layout stacking";

        "${mod}+41" = "fullscreen toggle";

        "${mod}+24" = "split h";
        "${mod}+38" = "split v";

        "${mod}+Control+Shift+31" = "move workspace to output eDP-1-1";
        "${mod}+Control+Shift+45" = "move workspace to output HDMI-0";

        #"${mod}+r" = "mode resize";
        #"${mod}+Shift+space" = "floating toggle";
        #"${mod}+space" = "focus mode_toggle";

        "122" = "exec pamixer -ud 2 && pamixer --get-volume > ${ob_file}";
        "123" = "exec pamixer -ui 2 && pamixer --get-volume > ${ob_file}";
        # "" = "exec pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > ${ob_file} ) || pamixer --get-volume > ${ob_file}";
        "171" = "exec playerctl next";
        "172" = "exec playerctl play-pause";
        "173" = "exec playerctl previous";
      };

      startup =
        lib.lists.forEach
          [
            "xrandr --output HDMI-0 --primary"
            "xrandr --output HDMI-0 --mode 3440x1440 --rate 100"
            "xrandr --output HDMI-0 --right-of eDP-1-1"
            "xss-lock --transfer-sleep-lock -- i3lock --nofork"
            "dropbox start"
            "nm-applet --indicator"
            "blueman-applet"
            "firefox"
            "sublime_text"
            "telegram-desktop"
            "slack"
            "keepassxc"
            "mkfifo ${ob_file} && tail -f ${ob_file} | ${ob}"
         ]
         (cmd: { command = cmd; notification = false; })
      ;

      assigns =
        {
          "${w_web}"  = [{ class = "Firefox"        ; } { class = "Chromium-browser"; }];
          "${w_dev}"  = [{ class = "Sublime_text"   ; }                                ];
          "${w_msg}"  = [{ class = "TelegramDesktop"; } { class = "Slack"           ; }];
          "${w_pass}" = [{ title = ".*KeePassXC$"   ; }                                ];
        };
    };
    extraConfig = ''
    '';
  };
}
