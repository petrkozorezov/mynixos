{config, pkgs, lib, ...}:
with lib; {
  # TODO generate search.json
  home.file =
    let
      profilesPath = ".mozilla/firefox"; # TODO get from appropriate place
      searchJson   = ./search.json;
    in
      mapAttrs'
        (name: profile:
          nameValuePair "${profilesPath}/${profile.path}/search.json.mozlz4" {
            source = pkgs.runCommandLocal "firefox-${name}-search.json" {} "${pkgs.mozlz4a}/bin/mozlz4a ${searchJson} $out";
          }
        )
        config.programs.firefox.profiles;
}