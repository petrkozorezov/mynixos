# TODO:
#  - [ ] fuzzel + swayr
#  - [ ] fuzzel pinetry
# fuzzel --layer=overlay --terminal='alacritty -e'
{ config, lib, pkgs, ... }: let
  mod      = "Mod4";
  terminal = "alacritty";
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
  wallpaper =
    builtins.fetchurl {
      url    = "https://wallpaperaccess.com/full/117782.png";
      sha256 = "0icwx5wib95yapb7i9vgy89wv9idcc2fbb69cgx57zadsfbdy4r3";
    };
    # http://getwallpapers.com/wallpaper/full/c/6/c/52323.jpg
    # http://getwallpapers.com/wallpaper/full/c/7/4/271955.jpg
    # https://wallup.net/wp-content/uploads/2016/01/260716-orange-flowers-abstract.jpg
    # https://www.pixel4k.com/wp-content/uploads/2019/07/orange-render-abstract_1563221459.jpg
    # https://wallpaperaccess.com/full/117782.png
  cursorsTheme    = "capitaine-cursors-white";
  gsettings       = "${pkgs.glib}/bin/gsettings";
  gnomeSchema     = "org.gnome.desktop.interface";
  importGsettings = pkgs.writeShellScript "import_gsettings.sh" ''
    ${gsettings} set ${gnomeSchema} gtk-theme ${config.gtk.theme.name}
    ${gsettings} set ${gnomeSchema} icon-theme ${config.gtk.iconTheme.name}
    ${gsettings} set ${gnomeSchema} cursor-theme ${config.gtk.gtk3.extraConfig.gtk-cursor-theme-name}
  '';
in {
  home.packages = with pkgs; [
    networkmanager-vpnc
    networkmanager-l2tp
    networkmanagerapplet
    pavucontrol

    qt5.qtwayland
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
    xwayland
    wallutils # TODO use it
    xorg.xhost

    dconf

    capitaine-cursors
    hicolor-icon-theme

    hack-font
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt5ct";
    XDG_CURRENT_DESKTOP  = "sway";
    SDL_VIDEODRIVER      = "wayland";
    # needs qt5.qtwayland in systemPackages
    QT_QPA_PLATFORM      = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };

  wayland.windowManager.sway = {
    enable = true;
    # xwayland = false;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = mod;
      fonts = {
        names = [ "Hack" ];
        size  = 10.0;
      };
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
            "exec grim -t jpeg -g \"`${geometry_cmd}`\" \"$HOME/Dropbox/Screenshots/$(date +%Y-%m-%d_%H-%M-%S).jpg\" && notify-desktop '${msg} screenshot taken'";
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
        #"${mod}+a"              = "exec rofi -show ssh"; # pass
        "${mod}+return"          = "exec ${terminal}";

        "${mod}+Shift+y"         = "reload"; # FIXME move to other key
        "${mod}+Shift+p"         = "restart";
        "${mod}+Shift+period"    = "exec swaynag -t warning -m 'You pressed the exit shortcut. Do you really want to exit sway? This will end your Wayland session.' -b 'Yes, exit sway' 'swaymsg exit'";
        "${mod}+Shift+semicolon" = "kill";

        "${mod}+apostrophe"      = "layout toggle split";
        "${mod}+q"               = "layout tabbed";
        "${mod}+j"               = "layout stacking";

        "${mod}+i"               = "fullscreen toggle";

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
            "${importGsettings}"
            "mkfifo ${ob_file} && tail -f ${ob_file} | ${ob}"
            "nm-applet --indicator"
            "mako"
            "blueman-applet"

            "firefox -P personal"
            "sublime_text"
            "telegram-desktop"
            "spotify --ozone-platform=wayland"
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
          xkb_layout   = "us,ru";
          xkb_variant  = "dvp,mac";
          xkb_options  = "grp:lctrl_lwin_rctrl_menu";
        };
      };

      output = {
        "*" = {
          bg = "${wallpaper} fill";
        };
      };

      seat = {
        "*" = {
          fallback      = "true";
          hide_cursor   = "5000";
          xcursor_theme = cursorsTheme;
        };
      };

      colors.focused = let
        # red = "#801a00";
        gray  = "#666666";
        white = "#ffffff";
      in {
        background  = gray;
        border      = gray;
        childBorder = gray;
        indicator   = gray;
        text        = white;
      };

    };
    extraConfig = ''
      default_border pixel 0

      set $mon_off            swaymsg "output * dpms off"
      set $mon_on             swaymsg "output * dpms on"
      set $lock_cmd           swaylock -f -i ${wallpaper}
      set $send_lock_signal   kill -USR1 `pidof swayidle`
      set $send_unlock_signal kill `pidof swaylock`

      exec swayidle -w timeout 310 '$lock_cmd'  timeout 300 '$mon_off' resume '$mon_on' before-sleep '$lock_cmd' lock '$lock_cmd' unlock '$send_unlock_signal'
      bindsym --to-code Control+Shift+backspace exec "$send_lock_signal && sleep 2 && $send_lock_signal"

      bindsym --to-code --locked XF86AudioRaiseVolume  exec pamixer -ui 2 && pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioLowerVolume  exec pamixer -ud 2 && pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioMute         exec pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > ${ob_file} ) || pamixer --get-volume > ${ob_file}
      bindsym --to-code --locked XF86AudioNext         exec playerctl next
      bindsym --to-code --locked XF86AudioPlay         exec playerctl play-pause
      bindsym --to-code --locked XF86AudioPrev         exec playerctl previous

      focus_follows_mouse no
      mouse_warping container

      # TODO moveto nix
      for_window [shell="xwayland"] title_format "%title [XWayland]"
    '';
  };

  gtk = {
    enable         = true;
    font.name      = "Hack 10";
    iconTheme.name = "hicolor"; # TODO use smth better
    # TODO https://github.com/mitch-kyle/monokai-gtk
    theme = {
      package = pkgs.gnome3.gnome-themes-extra;
      name    = "Adwaita-dark";
    };
    gtk2.extraConfig = ''
      gtk-cursor-theme-size = 16
      gtk-cursor-theme-name = "${cursorsTheme}"
      gtk-color-scheme = "base_color: #404552"
      gtk-color-scheme = "text_color: #ffffff"
      gtk-color-scheme = "bg_color: #383c4a"
      gtk-color-scheme = "fg_color: #ffffff"
      gtk-color-scheme = "tooltip_bg_color: #4B5162"
      gtk-color-scheme = "tooltip_fg_color: #ffffff"
      gtk-color-scheme = "selected_bg_color: #5294e2"
      gtk-color-scheme = "selected_fg_color: #ffffff"
      gtk-color-scheme = "insensitive_bg_color: #3e4350"
      gtk-color-scheme = "insensitive_fg_color: #7c818c"
      gtk-color-scheme = "notebook_bg: #404552"
      gtk-color-scheme = "dark_sidebar_bg: #353945"
      gtk-color-scheme = "link_color: #5294e2"
      gtk-color-scheme = "menu_bg: #2e2f29"
    '';
    gtk3 = {
      extraConfig = {
        gtk-cursor-theme-size = 16;
        gtk-cursor-theme-name = "${cursorsTheme}";
      };
    };
  };

  services.kanshi = {
    enable   = true;
    profiles =
      let
        macbook = {
          status   = "enable";
          criteria = "Apple Computer Inc Color LCD Unknown";
          scale    = 2.0;
        };
        portable = {
          status   = "enable";
          criteria = "DO NOT USE - RTK HDMI 0x00000101";
          scale    = 2.0;
        };
      in
      {
        "Main" = { outputs = [ macbook portable ]; };
      };
  };

  home.sessionVariables.ENABLE_VULKAN  = "true";
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
