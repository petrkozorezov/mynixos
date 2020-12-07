config:
let
  subl_path     = "sublime-text-3";
  packages_path = "${subl_path}/Packages";
  user_path     = "${packages_path}/User";
in
{
  subl_setting = {
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
  xdg.configFile = {
    "${user_path}/Preferences.sublime-settings".text =
      builtins.toJSON subl_setting;
    "${packages_path}/Nix" = fetchFromGithub {
      owner  = "brandonwamboldt";
      repo   = "sublime-nginx";
      rev    = "1.0.3";
      sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
    };
    "${packages_path}/" = fetchFromGithub {
      owner  = "brandonwamboldt";
      repo   = "sublime-nginx";
      rev    = "1.0.3";
      sha256 = "1ss7s3kal4vzhz7ld0yy2kvp1rk2w3i6fya0z3xd7nff9p31gqvw";
    };

}
