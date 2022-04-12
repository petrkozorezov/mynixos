{ config, lib, pkgs, ... }:

let
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
      url    = "https://i.imgur.com/OHkR2vt.png";
      sha256 = "13cbs5kgf8nyz8laasc60kpxhb3jrkb72dr3gr4lx98r5y3xdg4c";
    };
    # http://getwallpapers.com/wallpaper/full/c/6/c/52323.jpg
    # http://getwallpapers.com/wallpaper/full/c/7/4/271955.jpg
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
    rofi
    networkmanager_vpnc
    networkmanager_l2tp
    networkmanagerapplet
    pavucontrol

    qt5.qtwayland
    grim
    slurp                # screenshoter
    notify-desktop       # notifications
    wl-clipboard         # clipboard (wl-copy wl-paste)
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

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt5ct";

  wayland.windowManager.sway = {
    enable = true;
    # xwayland = false;
    systemdIntegration  = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = mod;
      fonts =
        {
          names = [ "Hack" ];
          size = 10.0;
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
      in
        workspaces               "${mod}" ""                      //
        workspaces         "Shift+${mod}" "move"                  //
        arrows                   "${mod}" "focus"                 //
        arrows             "Shift+${mod}" "move"                  //
        arrows           "Control+${mod}" "focus output"          //
        arrows     "Shift+Control+${mod}" "move workspace output" //
      {
        #"Alt+Shift+22"          = "exec loginctl lock-sessionx";
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

        "${mod}+minus"           = "exec grim -t jpeg -g \"$(slurp)\" \"$HOME/Dropbox/Screenshots/$(date +%Y-%m-%d_%H-%m-%S).jpg\"";
        # window
        # grim ~/Dropbox/Screenshots/${NAME} && notify-desktop "fullscreen screenshot taken $NAME"
        # region
        # GEOMETRY=`swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | .rect | "\(.x),\(.y) \(.width)x\(.height)"' | slurp`
        #grim -g "${GEOMETRY}" ~/Dropbox/Screenshots/${NAME} && notify-desktop "fullscreen screenshot taken $NAME"
        #"${mod}+r"              = "mode resize";
        "${mod}+Shift+space"     = "floating toggle";
        "${mod}+space"           = "focus mode_toggle";

        "XF86AudioRaiseVolume"   = "exec pamixer -ui 2 && pamixer --get-volume > ${ob_file}";
        "XF86AudioLowerVolume"   = "exec pamixer -ud 2 && pamixer --get-volume > ${ob_file}";
        "XF86AudioMute"          = "exec pamixer --toggle-mute && ( pamixer --get-mute && echo 0 > ${ob_file} ) || pamixer --get-volume > ${ob_file}";
        "XF86AudioNext"          = "exec playerctl next";
        "XF86AudioPlay"          = "exec playerctl play-pause";
        "XF86AudioPrev"          = "exec playerctl previous";

        # set $kbd_light light -s sysfs/leds/smc::kbd_backlight
        # set $mon_light light

        # "XF86MonBrightnessUp"   = "exec $mon_light -A 5 && $mon_light -G | cut -d'.' -f1 > ${ob_file}";
        # "XF86MonBrightnessDown" = "exec $mon_light -U 5 && $mon_light -G | cut -d'.' -f1 > ${ob_file}";

        # "XF86KbdBrightnessUp"   = "exec $kbd_light -A 5 && $kbd_light -G | cut -d'.' -f1 > ${ob_file}";
        # "XF86KbdBrightnessDown" = "exec $kbd_light -U 5 && $kbd_light -G | cut -d'.' -f1 > ${ob_file}";

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
            "firefox -P clean"
            "sublime_text"
            "telegram-desktop"
            # "slack"
            "discord"
            "MellowPlayer"
         ]
         (cmd: { command = cmd; })
      ;

      assigns =
        {
          "${w_web}"   = [ { app_id = "firefox"; } ];
          "${w_dev}"   = [ { app_id = "sublime_text"; } ];
          "${w_msg}"   = [ { app_id = "telegramdesktop"; } { class = "Slack"; } { class = "discord"; } ];
          "${w_music}" = [ { app_id = "ColinDuquesnoy.gitlab.com."; } ];
          "${w_calls}" = [ { class  = "Chromium-browser"; } ];
        };

      gaps = {
        inner = 10;
        outer = 5 ;
      };

      bars = [ { command = "waybar"; } ];

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

        "1133:49188:B16_b_02_USB-PS/2_Optical_Mouse" = {
          accel_profile = "adaptive";
          pointer_accel = "1.0";
        };

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

    };
    extraConfig = ''
      #bindswitch --reload lid:on  output eDP-1 disable
      #bindswitch --reload lid:off output eDP-1 enable

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
        fallback      true
        hide_cursor   5000
        xcursor_theme ${cursorsTheme}
      }

      # TODO moveto nix
      for_window [shell="xwayland"] title_format "%title [XWayland]"
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

  programs.zsh.initExtra =
    ''
      test -z $DISPLAY && \
      test 1 -eq $XDG_VTNR && \
      sway && \
      exit;
    '';

  gtk = {
    enable         = true;
    font.name      = "Hack 10";
    iconTheme.name = "hicolor"; # TODO set smth better
    # TODO https://github.com/mitch-kyle/monokai-gtk
    theme = {
      package = pkgs.gnome3.gnome_themes_standard;
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


#

  services.kanshi = {
    enable   = true;
    profiles =
      let
        xiaomiMiDisplay = {
          status   = "enable";
          criteria = "Unknown Mi Monitor 0x00000000";
          mode     = "3440x1440@144.000Hz";
          position = "0,0";
          scale    = 1.0;
        };
      in
      {
        "Main" = { outputs = [ xiaomiMiDisplay ]; };
      };
  };

  home.file."chromium-flags.conf".text = ''
    --enable-features=UseOzonePlatform
    --ozone-platform=wayland
    --use-vulkan
    --enable-features=Vulkan
  '';

  home.sessionVariables.ENABLE_VULKAN = "true";

}
