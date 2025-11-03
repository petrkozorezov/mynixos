{ ... }: {

  services.kanshi = let
    monitor1 = {
      status   = "enable";
      criteria = "DP-3";
      scale    = 2.0;
      mode     = "2560x1600@144Hz";
      position = "0,0";
    };
    monitor2 = {
      status   = "enable";
      criteria = "DP-1";
      scale    = 1.0;
      mode     = "3440x1440@180Hz";
      position = "1280,0";
      # adaptiveSync = true;
    };
  in {
    enable   = true;
    settings = [
      { profile.name = "single1"; profile.outputs = [ monitor1 ]; }
      { profile.name = "single2"; profile.outputs = [ monitor2 ]; }
      { profile.name = "dual"   ; profile.outputs = [ monitor1 monitor2 ]; }
    ];
  };
}
