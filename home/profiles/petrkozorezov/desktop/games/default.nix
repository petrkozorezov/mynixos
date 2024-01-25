{ pkgs, ... }: {
  imports = [
    ./vkquake.nix
  ];

  programs.mangohud = {
    enable = true;
    # https://dbeley.ovh/en/post/2023/03/23/the-mangohud-presets-used-by-the-steam-deck/
    settings = {
      # preset 2 from steam deck
      control             = "mangohud";
      fsr_steam_sharpness = 5;
      nis_steam_sharpness = 10;
      legacy_layout       = 0;
      horizontal          = true;
      gpu_stats           = true;
      cpu_stats           = true;
      cpu_power           = true;
      gpu_power           = true;
      ram                 = true;
      fps                 = true;
      frametime           = 0;
      hud_no_margin       = true;
      table_columns       = 14;
      frame_timing        = 1;

      # fsr  = true; # TODO enable
      vram = true;
    };
  };

  # run command
  # gamescope --expose-wayland -f -F fsr -r 144 -e -- mangohud steam -tenfoot -steamos
  # gamescope --expose-wayland -f -F fsr -W 2560 -H 1600 -r 144 -e -- mangohud steam -tenfoot -steamos
}


