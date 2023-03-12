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
            source =
              pkgs.runCommandLocal "firefox-${name}-search.json" {} ''
                cat ${searchJson} | ${pkgs.jq}/bin/jq -r tostring > tmp.json
                ${pkgs.mozlz4a}/bin/mozlz4a tmp.json $out
                rm -f tmp.json
              '';
          }
        )
        config.programs.firefox.profiles;
}
