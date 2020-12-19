{ config, lib, pkgs, ... }:

let
  mod      = "Mod4";
  terminal = "alacritty";
  w_term_0 = "0:";
  w_term_1 = "1:";
  w_term_2 = "2:";
  w_term_3 = "3:";
  w_web    = "6:";
  w_dev    = "7:λ";
  w_msg    = "8:Msg";
  w_mon    = "9:";
  w_pass   = "10:";
  sock     = "SWAYSOCK";
  ob       = "wob";
  ob_file  = "\$${sock}.${ob}";
  wallpaper = "~/.config/sway/wallpaper-big-1.jpg";
  # k = {
  #   "c" = ;
  #   "t" = ;
  #   "h" = ;
  #   "n" = ;
  # };
in {
  home.packages = with pkgs; [
    rofi
    networkmanager_vpnc
    networkmanager_l2tp
    networkmanagerapplet
    pavucontrol

    qt5.qtwayland
    grim
    slurp                # screenshoter
    notify-desktop  # notifications
    clipman wl-clipboard # clipboard (wl-copy wl-paste)
    ydotool              # gui automation tool
    waypipe              # wayland over ssh
    wob                  # volume control overlay
    wev                  # W events debugging tool
    swaylock
    swayidle
    xwayland
    wallutils # TODO use it
    xorg.xhost

    capitaine-cursors
    hicolor-icon-theme
  ];

  wayland.windowManager.sway = {
    enable = true;
    systemdIntegration = false;
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
          "${mod_}+43" = "${action} workspace ${w_term_0}";
          "${mod_}+29" = "${action} workspace ${w_term_1}";
          "${mod_}+57" = "${action} workspace ${w_term_2}";
          "${mod_}+58" = "${action} workspace ${w_term_3}";
          "${mod_}+30" = "${action} workspace ${w_web}"   ;
          "${mod_}+32" = "${action} workspace ${w_dev}"   ;
          "${mod_}+33" = "${action} workspace ${w_msg}"   ;
          "${mod_}+34" = "${action} workspace ${w_mon}"   ;
          "${mod_}+35" = "${action} workspace ${w_pass}"  ;
        };
        arrows = mod_: action: {
          "${mod_}+44" = "${action}  left";
          "${mod_}+45" = "${action}  down";
          "${mod_}+31" = "${action}    up";
          "${mod_}+46" = "${action} right";
        };
      in
        workspaces               "${mod}" ""                      //
        workspaces         "Shift+${mod}" "move"                  //
        arrows                   "${mod}" "focus"                 //
        arrows             "Shift+${mod}" "move"                  //
        arrows           "Control+${mod}" "focus output"          //
        arrows     "Shift+Control+${mod}" "move workspace output" //
      {
        "Alt+Shift+22"    = "exec loginctl lock-sessionx";
        "${mod}+40"       = "exec rofi -show combi";
        "${mod}+Shift+40" = "exec rofi -show ssh";
        "${mod}+36"       = "exec ${terminal}";

        "${mod}+Shift+26" = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+Shift+24" = "kill";
        "${mod}+Shift+25" = "restart";
        "${mod}+Shift+38" = "reload";

        "${mod}+25" = "layout tabbed";
        "${mod}+26" = "layout toggle split";
        "${mod}+27" = "layout stacking";

        "${mod}+41" = "fullscreen toggle";

        "${mod}+24" = "split h";
        "${mod}+38" = "split v";

        "${mod}+47" = "exec grim -t jpeg -g \"$(slurp)\" \"$HOME/Dropbox/Screenshots/$(date +%Y-%m-%d_%H-%m-%S).jpg\"";

        #"${mod}+r" = "mode resize";
        #"${mod}+Shift+space" = "floating toggle";
        #"${mod}+space" = "focus mode_toggle";

        "122" = "exec pamixer -ud 2 && pamixer --get-volume > ${ob_file}";
        "123" = "exec pamixer -ui 2 && pamixer --get-volume > ${ob_file}";
        # "" = "exec pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > ${ob_file} ) || pamixer --get-volume > ${ob_file}";
        "171" = "exec playerctl next";
        "172" = "exec playerctl play-pause";
        "173" = "exec playerctl previous";


        # set $kbd_light light -s sysfs/leds/smc::kbd_backlight
        # set $mon_light light

        # bindsym --to-code XF86MonBrightnessUp   exec $mon_light -A 5 && $mon_light -G | cut -d'.' -f1 > $SWAYSOCK.wob
        # bindsym --to-code XF86MonBrightnessDown exec $mon_light -U 5 && $mon_light -G | cut -d'.' -f1 > $SWAYSOCK.wob

        # bindsym --to-code XF86KbdBrightnessUp   exec $kbd_light -A 5 && $kbd_light -G | cut -d'.' -f1 > $SWAYSOCK.wob
        # bindsym --to-code XF86KbdBrightnessDown exec $kbd_light -U 5 && $kbd_light -G | cut -d'.' -f1 > $SWAYSOCK.wob

      };

      startup =
        lib.lists.forEach
          [
            "dropbox start"
            "nm-applet --indicator"
            "blueman-applet"
            "firefox"
            "sublime_text"
            "telegram-desktop"
            "slack"
            "keepassxc"
            "mkfifo ${ob_file} && tail -f ${ob_file} | ${ob}"
            "mako"
         ]
         (cmd: { command = cmd; })
      ;

      assigns =
        {
          "${w_web}"  = [{ app_id = "firefox"        ; } { class ="Chromium-browser"; }];
          "${w_dev}"  = [{ app_id = "sublime_text"   ; }                               ];
          "${w_msg}"  = [{ app_id = "telegramdesktop"; } { class ="Slack"           ; }];
          "${w_pass}" = [{ title  = ".*KeePassXC$"   ; }                               ];
        };

      gaps = {
        inner = 10;
        outer = 5 ;
      };

      bars = [
        {
          command = "waybar";
        }
      ];

      input = {
        "2:7:SynPS/2_Synaptics_TouchPad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          accel_profile  = "adaptive";
          pointer_accel  = "0.35";
        };

        "2:10:TPPS/2_ALPS_TrackPoint" = {
          dwt           = "enabled";
          accel_profile = "flat";
          pointer_accel = "0.35";
        };

        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_options = "grp:shifts_toggle,altwin:swap_alt_win";
        };

        "*" = {
          repeat_delay = "200";
          repeat_rate  = "70";
          xkb_layout   = "us,ru";
          xkb_variant  = "dvp,mac";
          xkb_options  = "grp:shifts_toggle,grp_led:num";
        };
      };

      output = {
        "eDP-1" = {
          pos  = "0 0";
        };
        "DP-1" = {
          mode = "3440x1440@100Hz";
          # pos  = "-760 1080";
        };
        "DP-2" = {
          mode = "3440x1440@100Hz";
          # pos  = "-760 1080";
        };
        "DP-3" = {
          mode = "3440x1440@100Hz";
          # pos  = "-760 1080";
        };

        "*" = {
          bg = "${wallpaper} fill";
        };
      };

    };
    extraConfig = ''
      bindswitch --reload lid:on  output eDP-1 disable
      bindswitch --reload lid:off output eDP-1 enable

      set $red #801a00
      set $red1 #cc2900
      set $white #ffffff
      set $gray #666666

      # class                 border  backgr. text    indicator child_border
      client.focused          $gray   $gray   $white  $gray     $gray
      #client.focused          $red1   $red    $white  $red      $red1

      popup_during_fullscreen leave_fullscreen
      default_border pixel 1

      # TODO sleep
      set $mon_off swaymsg "output * dpms off"
      set $mon_on  swaymsg "output * dpms on"
      set $lock_cmd swaylock -f -i ${wallpaper}
      set $lock_and_mon_off $lock_cmd && $mon_off
      set $send_lock_signal kill -USR1 `pidof swayidle`
      set $send_unlock_signal kill `pidof swaylock`
      exec swayidle -w timeout 310 '$lock_cmd'  timeout 300 '$mon_off' resume '$mon_on' before-sleep '$lock_cmd' lock '$lock_cmd' unlock '$send_unlock_signal'
      bindsym --to-code Control+Shift+backspace exec "$send_lock_signal && sleep 2 && $send_lock_signal"

      focus_follows_mouse no
      mouse_warping container

      seat seat0 {
        fallback true
        hide_cursor 5000
        xcursor_theme capitaine-cursors-white
      }

    '';
    extraSessionCommands =
      ''
        export SDL_VIDEODRIVER=wayland
        # needs qt5.qtwayland in systemPackages
        export QT_QPA_PLATFORM=wayland
        export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
        # Fix for some Java AWT applications (e.g. Android Studio),
        # use this if they aren't displayed properly:
        export _JAVA_AWT_WM_NONREPARENTING=1
        export XDG_CURRENT_DESKTOP=sway
      '';
  };
}

# seat seat0 {
#   fallback true
# }
# seat seat1 {
#   attach "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse_System_Control"
#   attach "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse_Consumer_Control"
#   attach "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse_Consumer_Control"
#   attach "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse_Keyboard"
#   attach "1133:49284:Logitech_G102_Prodigy_Gaming_Mouse"
#   attach "7504:24866:Ultimate_Gadget_Laboratories_Ultimate_Hacking_Keyboard"
# }


# Gdk-Message: 22:39:24.984: Unable to load hand2 from the cursor theme
# Gdk-Message: 22:39:25.010: Unable to load hand2 from the cursor theme
# Gdk-Message: 22:39:27.917: Unable to load sb_h_double_arrow from the cursor theme
# Gdk-Message: 22:39:27.917: Unable to load sb_h_double_arrow from the cursor theme
# Gdk-Message: 22:39:28.022: Unable to load hand2 from the cursor theme
