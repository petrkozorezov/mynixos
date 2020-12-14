config:
let
  sublPath     = "sublime-text-3";
  packagesPath = "${sublPath}/Packages";
  userPath     = "${packagesPath}/User";
  sublSetting = {
    auto_complete = false;
    auto_match_enabled = false;
    binary_file_patterns =
    [
      "*.jpg" "*.jpeg" "*.png" "*.gif" "*.ttf" "*.tga" "*.dds" "*.ico" "*.eot" "*.pdf" "*.swf" "*.jar" "*.zip" "*.beam"
    ];
    color_scheme = "Packages/User/Monokai (SL).tmTheme";
    font_face = "Hack";
    font_size = 14;
    ignored_packages = [];
    tab_size = 2;
    theme = "Soda Dark.sublime-theme";
    translate_tabs_to_spaces = true;
    trim_trailing_white_space_on_save = true;
    update_check = false;
    vintage_start_in_command_mode = true;
  };
  sublKeymap =
    [
      { keys = ["ctrl+*"      ]; command = "focus_side_bar";                                  }
      { keys = ["ctrl+)"      ]; command = "focus_group"   ; args = { group        = 0   ; }; }
      { keys = ["ctrl+)"      ]; command = "focus_group"   ; args = { group        = 0   ; }; }
      { keys = ["ctrl++"      ]; command = "focus_group"   ; args = { group        = 1   ; }; }
      { keys = ["ctrl+]"      ]; command = "focus_group"   ; args = { group        = 2   ; }; }
      { keys = ["ctrl+shift+)"]; command = "move_to_group" ; args = { group        = 0   ; }; }
      { keys = ["ctrl+shift++"]; command = "move_to_group" ; args = { group        = 1   ; }; }
      { keys = ["ctrl+shift+]"]; command = "move_to_group" ; args = { group        = 2   ; }; }
      { keys = ["ctrl+shift+a"]; command = "align_tab"     ; args = { live_preview = true; }; }
    ];
in
{
  xdg.configFile = {
    "${userPath}/Preferences.sublime-settings".text =
      builtins.toJSON sublSetting;
    "${userPath}/Default (Linux).sublime-keymap".text =
      builtins.toJSON sublKeymap;
  };
  #   "${packagesPath}/Nix" = fetchFromGithub {
  #     owner  = "brandonwamboldt";
  #     repo   = "sublime-nginx";
  #     rev    = "1.0.3";
  #     sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
  #   };
  #   "${packagesPath}/" = fetchFromGithub {
  #     owner  = "brandonwamboldt";
  #     repo   = "sublime-nginx";
  #     rev    = "1.0.3";
  #     sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
  #   };
}


