{ config, pkgs, ... }:
let
  sublPath          = "sublime-text-3";
  packagesPath      = "${sublPath}/Packages";
  userPath          = "${packagesPath}/User";
  localPath         = "${sublPath}/Local";
  installedPkgsPath = "${sublPath}/Installed Packages";
  packageStorage    = ".cache/${sublPath}/Package Storage";
  sublSetting       = {
    # ui
    theme                             = "Afterglow.sublime-theme";
    sidebar_size_13                   = true;
    color_scheme                      = "Packages/Theme - Afterglow/Afterglow-monokai.tmTheme";
    font_face                         = "JetBrains Mono";
    font_size                         = 14;
    overlay_scroll_bars               = "enabled";
    auto_complete                     = true;
    auto_match_enabled                = false;
    tab_size                          = 2;
    tabs_small                        = true;
    translate_tabs_to_spaces          = true;
    trim_trailing_white_space_on_save = "all";
    ensure_newline_at_eof_on_save     = true;
    update_check                      = false;
    copy_with_empty_selection         = true;
    highlight_line                    = true;
    ignored_packages = [
      "Vintage"
    ];
    folder_exclude_patterns = [
      ".git"
    ];
    binary_file_patterns = [
      "*.jpg" "*.jpeg" "*.png" "*.gif" "*.ttf" "*.tga" "*.dds" "*.ico" "*.eot" "*.pdf" "*.swf" "*.jar" "*.zip" "*.beam"
    ];
    node = pkgs.nodejs;
  };
  sublKeymap =
    [
      { keys = ["alt+tab"     ]; command = "toggle_side_bar"; }
      { keys = ["ctrl+*"      ]; command = "focus_side_bar" ; }
      { keys = ["ctrl+)"      ]; command = "focus_group"   ; args = { group        = 0   ; }; }
      { keys = ["ctrl++"      ]; command = "focus_group"   ; args = { group        = 1   ; }; }
      { keys = ["ctrl+]"      ]; command = "focus_group"   ; args = { group        = 2   ; }; }
      { keys = ["ctrl+shift+)"]; command = "move_to_group" ; args = { group        = 0   ; }; }
      { keys = ["ctrl+shift++"]; command = "move_to_group" ; args = { group        = 1   ; }; }
      { keys = ["ctrl+shift+]"]; command = "move_to_group" ; args = { group        = 2   ; }; }
      { keys = ["ctrl+shift+a"]; command = "align_tab"     ; args = { live_preview = true; }; }
      { keys = ["ctrl+alt+right"]; command = "lsp_symbol_definition"  ; } # alt+'-' -- back
      { keys = ["ctrl+alt+left" ]; command = "lsp_symbol_references"  ; }
      { keys = ["ctrl+alt+up"   ]; command = "lsp_code_actions"       ; }
      { keys = ["ctrl+alt+down" ]; command = "lsp_hover"              ; }
    ];
  packages = {
    bootstrapped        = true;
    in_process_packages = [];
    installed_packages  = [
      # ui
      "Theme - Afterglow"
      "SideBarEnhancements"
      "WordHighlight"
      "Terminus"

      # editing
      "AlignTab"
      "ChangeQuotes"
      "EditorConfig"
      "Pretty JSON"
      "Text Pastry"
      "ColorHelper"
      "INI"

      # languages
      "LSP"
      "LSP-json"
      # "LSP-file-watcher-chokidar" # periodically eats too much CPU
      # "LSP-bash"
      "Elixir"
      "ElixirSyntax"
      "Nix"
      "Protocol Buffer Syntax"
      "ThriftSyntax"
      "TOML"
      "Dockerfile Syntax Highlighting"
      "LSP-dockerfile"
      "Coq"
      "Idris Syntax"
      "LSP-typescript"
      "LSP-eslint"
      "LSP-pyright"
      "Rust Enhanced"
      # "LSP-rust-analyzer" # TODO use rust-analyzer from devenv
      "Ethereum"
      "MarkdownEditing"
      # "LSP-ltex-ls"
      "TLAPlus"

      # "Debugger" # shows a lot errors

      # VCS
      "SublimeGit"
      "GitGutter"
      "FileDiffs"

      "Direnv"
    ];
    auto_upgrade_ignore = [ "Package Control" ];
  };
  lsp = {
    clients =
      # TODO nil (ls for nix)
      {
        erlang-ls =
          {
            enabled  = true;
            command  = [ "erlang_ls" "--transport" "stdio" "" ];
            selector = "source.erlang";
          };
        elixir-ls = {
          enabled  = true;
          selector = "source.elixir";
          command  = [ "elixir-ls" ];
        };
      };
    initialize_timeout = 30;
    log_debug    = false;
    log_server   = false;
    log_stderr   = false;
    log_payloads = false;
  };
  lspTypescript.settings = {
    "typescript.format.semicolons" = "remove";
  };
  rustAnalyzer.settings = {
    "rust-analyzer.inlayHints.enable" = false;
    "rust-analyzer.diagnostics".disabled = [
      "unresolved-proc-macro"
    ];
  };
in
{
  xdg = {
    configFile = {
      "${userPath}/Preferences.sublime-settings".text =
        builtins.toJSON sublSetting;
      "${userPath}/Default (Linux).sublime-keymap".text =
        builtins.toJSON sublKeymap;
      "${userPath}/LSP.sublime-settings".text =
        builtins.toJSON lsp;
      "${userPath}/Package Control.sublime-settings".text =
        builtins.toJSON packages;
      "${userPath}/LSP-typescript.sublime-settings".text =
        builtins.toJSON lspTypescript;
      "${userPath}/LSP-rust-analyzer.sublime-settings".text =
        builtins.toJSON rustAnalyzer;

      # TODO pass by config
      "${localPath}/License.sublime_license".source = config.zoo.secrets.filesPath + "/sublime.license";
      "${installedPkgsPath}/Package Control.sublime-package".source =
        builtins.fetchurl {
          url    = "https://github.com/wbond/package_control/releases/download/4.0.1/Package.Control.sublime-package";
          sha256 = "1564lj73wgn2kqhf2jmg98c6c7r8ygv9ipfvv89qpsva9ails5mh";
        };
    };
  };

  home.packages = with pkgs; [
    sublime4
    jetbrains-mono

    # TODO remove(?)
    mdl # markdownlint
    shellcheck
    adoptopenjdk-jre-bin
  ];
}
