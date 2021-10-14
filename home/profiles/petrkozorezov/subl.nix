{ config, pkgs, ... }:
let
  sublPath          = "sublime-text-3";
  packagesPath      = "${sublPath}/Packages";
  userPath          = "${packagesPath}/User";
  localPath         = "${sublPath}/Local";
  installedPkgsPath = "${sublPath}/Installed Packages";
  sublSetting       = {
    auto_complete                     = true;
    auto_match_enabled                = false;
    color_scheme                      = "Packages/MonokaiFree/MonokaiFree.tmTheme";
    font_face                         = "JetBrains Mono";
    font_size                         = 14;
    ignored_packages                  = [];
    tab_size                          = 2;
    theme                             = "Soda Dark.sublime-theme";
    translate_tabs_to_spaces          = true;
    trim_trailing_white_space_on_save = true;
    ensure_newline_at_eof_on_save     = false;
    update_check                      = false;
    vintage_start_in_command_mode     = true;
    copy_with_empty_selection         = true;
    highlight_line                    = true;
    folder_exclude_patterns           = [ "_build" ".git" ".cache" ];
    binary_file_patterns =
      [
        "*.jpg" "*.jpeg" "*.png" "*.gif" "*.ttf" "*.tga" "*.dds" "*.ico" "*.eot" "*.pdf" "*.swf" "*.jar" "*.zip" "*.beam"
      ];
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
  packages = {
    bootstrapped        = true;
    in_process_packages = [];
    installed_packages  =
    [
      "MonokaiFree"
      "Theme - Soda"
      "AlignTab"
      "Elixir"
      "GitGutter"
      "Nix"
      "EditorConfig"
      "Pretty JSON"
      "Protocol Buffer Syntax"
      "SideBarEnhancements"
      "SublimeGit"
      "ThriftSyntax"
      "TOML"
      "WordHighlight"
      "LSP"
      "Dockerfile Syntax Highlighting"
      "Coq"
      "TypeScript"
      # doesn't work
      #"Markdown Preview"
      #"TabNine"
    ];
  };
  lsp = {
    clients =
      {
        erlang-ls =
          {
            enabled  = true;
            command  = [ "${pkgs.erlang-ls}/bin/erlang_ls" "--transport" "stdio" "" ];
            selector = "source.erlang";
          };
        rust-analyzer =
          {
            enabled  = true;
            command  = [ "${pkgs.rust-analyzer}/bin/rust-analyzer" ];
            selector = "source.rust";
          };
      };
    initialize_timeout = 30;
    log_debug    = false;
    log_server   = false;
    log_stderr   = false;
    log_payloads = false;
  };
  # rustFmt = {
  #   format_on_save = true;
  #   executable     = ["${pkgs.rustfmt}/bin/rustfmt"];
  # };
in
{
  xdg.configFile = {
    "${userPath}/Preferences.sublime-settings".text =
      builtins.toJSON sublSetting;
    "${userPath}/Default (Linux).sublime-keymap".text =
      builtins.toJSON sublKeymap;
    "${userPath}/LSP.sublime-settings".text =
      builtins.toJSON lsp;
    "${userPath}/Package Control.sublime-settings".text =
      builtins.toJSON packages;
    # "${userPath}/RustFmt.sublime-settings".text =
    #   builtins.toJSON rustFmt;
    # TODO pass by config
    "${localPath}/License.sublime_license".source = config.zoo.secrets.filesPath + "/sublime.license";
    "${installedPkgsPath}/Package Control.sublime-package".source =
      builtins.fetchurl {
        name   = "sublime-package-control";
        url    = "https://packagecontrol.io/Package%20Control.sublime-package";
        sha256 = "0ffi4qn0ndhqphnggy02mhzrqvv5n8c57f23rn44rj1l9ha3fyc1";
      };
  };
  home.packages = [ pkgs.sublime3 ];
}
