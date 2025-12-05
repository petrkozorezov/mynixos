# TODO:
#  - [ ] fuzzel + swayr
#  - [ ] fuzzel pinetry
#  - переопределить WLR_XWAYLAND и добавить -hidpi
# fuzzel --layer=overlay --terminal='alacritty -e'
{ config, lib, pkgs, ... }: let
  mod      = "Mod4";
  terminal = config.home.sessionVariables.TERMINAL;
  w_term_0 = "00";
  w_term_1 = "01";
  w_term_2 = "02";
  w_calls  = "05";
  w_web    = "06";
  w_dev    = "07";
  w_msg    = "08";
  w_mon    = "09";
  w_music  = "10";
  sock     = "SWAYSOCK";
  ob       = "wob";
  ob_file  = "\$${sock}.${ob}";
  wallpaper = config.stylix.image;
in {
  home.packages = with pkgs; [
    grim
    slurp                # screenshoter
    notify-desktop       # notifications
    wl-clipboard         # clipboard (wl-copy wl-paste)
    wlprop               # window info
    ydotool              # gui automation tool
    waypipe              # wayland over ssh
    wob                  # volume control overlay
    wev                  # W events debugging tool
    swaylock
    swayidle
    # wallutils # TODO use it
    xorg.xhost
    udiskie
    kanshi
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = mod;
      gaps = {
        inner        = 1;
        outer        = 1;
        smartGaps    = true;
      };
      bindkeysToCode = true;
      keybindings = let
        workspaces = mod_: action: {
          "${mod_}+d"     = "${action} workspace ${w_term_0}";
          "${mod_}+f"     = "${action} workspace ${w_term_1}";
          "${mod_}+b"     = "${action} workspace ${w_term_2}";
          "${mod_}+m"     = "${action} workspace ${w_calls}" ;
          "${mod_}+g"     = "${action} workspace ${w_web}"   ;
          "${mod_}+r"     = "${action} workspace ${w_dev}"   ;
          "${mod_}+l"     = "${action} workspace ${w_msg}"   ;
          "${mod_}+slash" = "${action} workspace ${w_mon}"   ;
          "${mod_}+s"     = "${action} workspace ${w_music}" ;
        };
        arrows = mod_: action: {
          "${mod_}+c" = "${action}    up";
          "${mod_}+t" = "${action}  down";
          "${mod_}+h" = "${action}  left";
          "${mod_}+n" = "${action} right";
        };
        kbd_light_dev = "sysfs/leds/smc::kbd_backlight";
        mon_light_dev = "sysfs/backlight/auto";
        exec_light = device: action:
          "exec light -s ${device} ${action} && light -G | cut -d'.' -f1 > ${ob_file}";
        take_screenshot =
          msg: geometry_cmd:
            "exec grim -t jpeg -g \"`${geometry_cmd}`\" \"$HOME/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).jpg\" && notify-desktop '${msg} screenshot taken'";
      in
        workspaces               "${mod}" ""                      //
        workspaces         "Shift+${mod}" "move"                  //
        arrows                   "${mod}" "focus"                 //
        arrows             "Shift+${mod}" "move"                  //
        arrows           "Control+${mod}" "focus output"          //
        arrows     "Shift+Control+${mod}" "move workspace output" //
      {
        "${mod}+u"               = "exec rofi -show run";
        "${mod}+Shift+u"         = "exec rofi -show drun";
        "${mod}+e"               = "exec rofi -show ssh";

        "${mod}+return"          = "exec ${terminal}";

        "${mod}+Shift+y"         = "reload"; # FIXME move to other key
        "${mod}+Shift+p"         = "restart";
        "${mod}+Shift+period"    = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+Shift+semicolon" = "kill";

        "${mod}+apostrophe"      = "layout toggle split";
        "${mod}+q"               = "layout tabbed";
        "${mod}+j"               = "layout stacking";

        "${mod}+i"               = "fullscreen toggle";

        "${mod}+a"               = "focus parent";
        # bindsym $mod+d focus child

        "${mod}+x"               = "split h";
        "${mod}+k"               = "split v";

        "${mod}+minus"               = take_screenshot "region"     "slurp";
        # BUG sway handles comma as command separator
        # "${mod}+Shift+minus"         = take_screenshot "window"     "swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | \"\\(.x),\\(.y) \\(.width)x\\(.height)\"' | slurp -r";
        "${mod}+Shift+Control+minus" = take_screenshot "fullscreen" "slurp -or";

        #"${mod}+r"              = "mode resize";
        "${mod}+Shift+space"     = "floating toggle";
        "${mod}+space"           = "focus mode_toggle";

        "XF86MonBrightnessUp"   = exec_light mon_light_dev "-A 5";
        "XF86MonBrightnessDown" = exec_light mon_light_dev "-U 5";
        "XF86KbdBrightnessUp"   = exec_light kbd_light_dev "-A 5";
        "XF86KbdBrightnessDown" = exec_light kbd_light_dev "-U 5";
      };

      startup =
        lib.lists.forEach
          [
            "kanshi"
            "mkfifo ${ob_file} && tail -f ${ob_file} | ${ob}"
            "nm-applet --indicator"
            "mako"
            "blueman-applet"
            "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
            "udiskie --tray"

            "firefox -P personal"
            "firefox -P clean"
            "firefox -P work"
            "sublime_text"
            "telegram-desktop"
            "slack --ozone-platform=wayland"

            "spotify --ozone-platform=wayland"
            "easyeffects"
         ]
         (cmd: { command = cmd; })
      ;

      assigns =
        {
          "${w_web}"   = [ { app_id = "firefox"; } ];
          "${w_dev}"   = [ { app_id = "sublime_text"; } ];
          # "${w_music}" = [ { name   = "Spotify Premium"; } ];
          "${w_msg}"   = [ { app_id = "org.telegram.desktop"; } { class = "Slack"; } { class = "discord"; } ];
          "${w_calls}" = [ { class  = "Chromium-browser"; } ];
        };

      window.border = 0;

      bars = [ { command = "waybar"; } ];

      input = let
        mbp_touchpad = {
          tap            = "enabled";
          natural_scroll = "disabled";
        };
        mbp_keyboard = {
          xkb_options = "ctrl:nocaps,grp:lctrl_toggle";
        };
      in {
        "2:7:SynPS/2_Synaptics_TouchPad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "disabled";
          accel_profile  = "adaptive";
          pointer_accel  = "0.35";
        };

        "1452:628:bcm5974" = mbp_touchpad;
        "1452:602:bcm5974" = mbp_touchpad;

        "2:10:TPPS/2_ALPS_TrackPoint" = {
          dwt           = "enabled";
          accel_profile = "flat";
          pointer_accel = "0.35";
        };

        "1133:49188:B16_b_02_USB-PS/2_Optical_Mouse" = {
          accel_profile = "adaptive";
          pointer_accel = "1.0";
        };

        "1452:602:Apple_Inc._Apple_Internal_Keyboard_\/_Trackpad" = mbp_keyboard;
        "1452:628:Apple_Inc._Apple_Internal_Keyboard_\/_Trackpad" = mbp_keyboard;

        "*" = {
          repeat_delay = "200";
          repeat_rate  = "70";
          xkb_layout   = "us,ru,us";
          xkb_variant  = "dvp,mac,";
          xkb_options  = "grp:lctrl_lwin_rctrl_menu";
        };
      };

      seat = {
        "*" = {
          fallback      = "true";
          hide_cursor   = "5000";
        };
      };
    };
    extraConfig = let
      timeouts = {
        screensaver = 300;
        monOff      = 420;
        lock        = 430;
      };
    in ''
      default_border pixel 0

      set $mon_off            swaymsg "output * dpms off"
      set $mon_on             swaymsg "output * dpms on"
      set $lock_cmd           swaylock -f -i ${wallpaper}
      set $send_lock_signal   kill -USR1 `pidof swayidle`
      set $send_unlock_signal kill `pidof swaylock`
      set $screen_saver_start ${terminal} --class=screen_saver -e ${pkgs.unimatrix}/bin/unimatrix -s 98 -t ${toString(timeouts.monOff - timeouts.screensaver)} -i
      set $screen_saver_stop  kill `pidof unimatrix`

      for_window [app_id="screen_saver"] fullscreen global;

      exec swayidle -w \
        timeout ${toString(timeouts.screensaver)}  '$screen_saver_start' resume '$screen_saver_stop' \
        timeout ${toString(timeouts.monOff     )}  '$mon_off'            resume '$mon_on' \
        timeout ${toString(timeouts.lock       )}  '$lock_cmd' \
        before-sleep '$lock_cmd' \
        lock         '$lock_cmd' \
        unlock       '$send_unlock_signal'

      bindsym --to-code Control+Shift+backspace exec "$send_lock_signal && sleep 2 && $send_lock_signal"

      bindsym --to-code --locked XF86AudioRaiseVolume  exec pamixer -ui 2 && pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioLowerVolume  exec pamixer -ud 2 && pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioMute         exec pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > ${ob_file} ) || pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioNext         exec playerctl next
      bindsym --to-code --locked XF86AudioPlay         exec playerctl play-pause
      bindsym --to-code --locked XF86AudioPrev         exec playerctl previous

      focus_follows_mouse no
      mouse_warping container

      # TODO move to nix
      for_window [shell="xwayland"] title_format "%title [XWayland]"
    '';
  };

  xdg.configFile."kanshi/config".text = let
    monitor1 = "output \"DP-3\" enable mode 2560x1600@144Hz position 0,0 scale 2.0";
    monitor2 = "output \"DP-1\" enable mode 3440x1440@180Hz position 1280,0 scale 1.0";
  in ''
    profile single1 {
      ${monitor1}
    }

    profile single2 {
      ${monitor2}
    }

    profile dual {
      ${monitor1}
      ${monitor2}
    }
    '';
}
