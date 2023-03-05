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
    ignored_packages                  = [];
    tab_size                          = 2;
    tabs_small                        = true;
    translate_tabs_to_spaces          = true;
    trim_trailing_white_space_on_save = "all";
    ensure_newline_at_eof_on_save     = true;
    update_check                      = false;
    vintage_start_in_command_mode     = true;
    copy_with_empty_selection         = true;
    highlight_line                    = true;
    folder_exclude_patterns           = [ "_build" ".git" ".cache" ];
    binary_file_patterns =
      [
        "*.jpg" "*.jpeg" "*.png" "*.gif" "*.ttf" "*.tga" "*.dds" "*.ico" "*.eot" "*.pdf" "*.swf" "*.jar" "*.zip" "*.beam"
      ];
    node = pkgs.nodejs;
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

      # languages
      "LSP"
      "LSP-json"
      # "LSP-file-watcher-chokidar" # periodically eats too much CPU
      # "LSP-bash"
      "Elixir"
      "ElixirSyntax"
      "LSP-elixir"
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
      "LSP-rust-analyzer"
      "Ethereum"
      "MarkdownEditing"
      # "LSP-ltex-ls"
      "TLAPlus"

      # "Debugger" # shows a lot errors

      # VCS
      "SublimeGit"
      "GitGutter"
      "FileDiffs"
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
    # "rust-analyzer.cargo.loadOutDirsFromCheck" = true;
    # "rust-analyzer.procMacro.enable" = false;
    # "rust-analyzer.experimental.procAttrMacros" = false;
    "rust-analyzer.diagnostics".disabled = [
      "unresolved-proc-macro"
    ];
  };

  # rustFmt = {
  #   format_on_save = true;
  #   executable     = ["${pkgs.rustfmt}/bin/rustfmt"];
  # };

  lspElixir.settings.elixirLS = {
    dialyzerEnabled  = true;
    dialyzerWarnOpts = [
      "error_handling"
      "unknown"
      "no_return"
      "no_unused"
    ];
    dialyzerFormat = "dialyxir_short";
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
      "${userPath}/LSP-elixir.sublime-settings".text =
        builtins.toJSON lspElixir;

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
  };

  home.file = {
    # TODO other LSP packages
    "${packageStorage}/LSP-rust-analyzer/rust-analyzer".source = "${pkgs.rust-analyzer}/bin/rust-analyzer";
  };
  home.packages = with pkgs; [
    jetbrains-mono

    erlang
    nodejs
    elixir_1_14
    rustc cargo
    mdl # markdownlint
    shellcheck
    adoptopenjdk-jre-bin

    (sublime4.overrideAttrs ({ propagatedBuildInputs ? [], ... }: {
      propagatedBuildInputs =
        propagatedBuildInputs ++ [];
    }))

    # oni2 # just to look on it
  ];
}
