# TODO base16:
#  - telegram
#  - sublime
#  - firefox
# https://gitlab.com/EmilienMottet/base16-telegram-desktop

# потестить qt можно через qt5ct/qt6ct
{ config, pkgs, deps, lib, ... }: {
  stylix = {
    enable = true;
    targets.qt.enable = true;

    # possible wallpapers
    # http://getwallpapers.com/wallpaper/full/c/6/c/52323.jpg
    # http://getwallpapers.com/wallpaper/full/c/7/4/271955.jpg
    # https://wallup.net/wp-content/uploads/2016/01/260716-orange-flowers-abstract.jpg
    # https://www.pixel4k.com/wp-content/uploads/2019/07/orange-render-abstract_1563221459.jpg
    # https://wallpaperaccess.com/full/117782.png
    # https://images.unsplash.com/photo-1511097646266-61a6d20ed830?q=85&w=2640
    # https://unsplash.com/photos/parorama-photography-of-mountain-under-cloudy-sky-Ni4NgA64TFQ
    # https://unsplash.com/photos/brown-house-near-shoreline-and-mountains-at-daytime-wX-NB8xFD3w
    # https://unsplash.com/photos/IuSemNxGS88/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzM5NDcwNjEwfA
    # image = builtins.fetchurl {
    #   name   = "wallpaper";
    #   url    = "https://unsplash.com/photos/wX-NB8xFD3w/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzM5MzkyMjU5fA&force=true";
    #   sha256 = "09ybcpcw9garhkvc5r7kbna59nb1rlfgvi6mdcgwcp3wsj9jzq4f";
    # };
    # https://unsplash.com/photos/landscape-photo-of-mountain-alps-vddccTqwal8
    image = builtins.fetchurl {
      name   = "wallpaper";
      url    = "https://unsplash.com/photos/Y3PD_9c2xms/download?ixid=M3wxMjA3fDB8MXxhbGx8fHx8fHx8fHwxNzM5MzAxNDE2fA&force=true";
      sha256 = "1knl379zjs06zb22xwxh7ax1rfq4wf9pn4yis5jdrililn7hks73";
    };

    polarity = "dark";

    # базовый акцентный цвет -- base0D
    #
    # https://github.com/chriskempson/base16
    # https://github.com/tinted-theming/home
    # https://github.com/SenchoPens/base16.nix
    #
    # base16Scheme = deps.inputs.tt-schemes + "/base16/woodland.yaml";
    # base16Scheme = deps.inputs.tt-schemes + "/base16/zenburn.yaml"; # слишком много молока
    # base16Scheme = deps.inputs.tt-schemes + "/base16/standardized-dark.yaml";
    # base16Scheme = deps.inputs.tt-schemes + "/base16/decaf.yaml";
    base16Scheme = deps.inputs.tt-schemes + "/base16/darcula.yaml";

    opacity = {
      desktop  = 0.6;
      terminal = 0.9;
    };

    iconTheme = {
      enable  = true;
      package = pkgs.arc-icon-theme;
      light   = "Arc";
      dark    = "Arc";
    };

    cursor = {
      name    = "capitaine-cursors-white";
      package = pkgs.capitaine-cursors;
      size    = 24; # NOTE если поставить не кратное 24 в некоторых приложениях будут спецэффекты (easyeffects)
    };

    fonts = {
      monospace = {
        # package = pkgs.jetbrains-mono;
        # package = pkgs.nerdfonts.override { fonts = [ "JetBrainsMono" ]; };
        package = pkgs.nerd-fonts.jetbrains-mono;
        name    = "JetBrainsMono Nerd Font";
        # package = pkgs.hack-font;
        # name    = "Hack";
      };
      sizes = {
        desktop      = 9;
        applications = 9;
        terminal     = 10;
        popups       = 9;
      };
    };
  };

  # qt fonts
  # TODO upstream
  xdg.configFile = let
    cfg = config.stylix;
    qt5fontConf = ''
      [Fonts]
      fixed="${cfg.fonts.monospace.name},${toString cfg.fonts.sizes.applications},-1,5,50,0,0,0,0,0,Condensed"
      general="${cfg.fonts.sansSerif.name},${toString cfg.fonts.sizes.applications},-1,5,50,0,0,0,0,0,Condensed"
      '';
    qt6fontConf = ''
      [Fonts]
      fixed="${cfg.fonts.monospace.name},${toString cfg.fonts.sizes.applications},-1,5,200,0,0,0,0,0,0,0,0,0,0,1,ExtraLight"
      general="${cfg.fonts.sansSerif.name},${toString cfg.fonts.sizes.applications},-1,5,200,0,0,0,0,0,0,0,0,0,0,1,ExtraLight"
      '';
  in
    (lib.mkIf (cfg.enable && cfg.targets.qt.enable && config.qt.platformTheme.name == "qtct") {
      "qt5ct/qt5ct.conf".text = qt5fontConf;
      "qt6ct/qt6ct.conf".text = qt6fontConf;
    });
}
