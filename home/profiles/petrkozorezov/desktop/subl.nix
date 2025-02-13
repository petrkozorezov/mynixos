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
    font_face                         = config.stylix.fonts.monospace.name;
    font_size                         = config.stylix.fonts.sizes.terminal;
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
      # "LSP-eslint"
      "LSP-biome" # rust based линтер для js/ts
      "LSP-pyright"
      "Rust Enhanced"
      # "LSP-rust-analyzer" # TODO use rust-analyzer from devenv
      "Ethereum"
      "MarkdownEditing"
      # "LSP-ltex-ls"
      "TLAPlus"
      "Nushell"

      # "Debugger" # shows a lot errors

      # VCS
      "SublimeGit"
      "GitGutter"
      "FileDiffs"

      # others
      "Direnv"      # применение direvn окружения при в проекте
      "ApplySyntax" # возможность кастомно настраивать включение синтаксиса
      "UnicodeMath" # ввод unicode'ых символов через \
      "PackageResourceViewer"
    ];
    auto_upgrade_ignore = [
      # не убирать, иначе будут конфликты при деплое
      "Package Control"
    ];
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
  colorHelper = {
    color_rules = [
      {
        name = "Nix";
        syntax_files = [ "Nix/nix" ];
        base_scopes = [ "source.nix" ];
        color_class = "css-level-4";
        scanning = [ "string.quoted.double.nix" ];
      }
      {
        name = "YAML";
        syntax_files = [ "YAML/YAML" ];
        base_scopes = [ "source.yaml" ];
        color_class = "css-level-4";
        scanning = [ "meta.string.yaml" "string.quoted.double.nix" ];
      }
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
      "${userPath}/color_helper.sublime-settings".text =
        builtins.toJSON colorHelper;
      "${packagesPath}/Lean.sublime-syntax".source = ./subl/lean.sublime-syntax;

      # TODO pass by config
      "${localPath}/License.sublime_license".source = config.mynixos.secrets.filesPath + "/sublime.license";
      "${installedPkgsPath}/Package Control.sublime-package".source =
        builtins.fetchurl {
          url    = "https://github.com/wbond/package_control/releases/download/4.0.7/Package.Control.sublime-package";
          sha256 = "07w18kk9x52pf5rd1lxxbq0nqahdkkybv01p766vy0vjihr19rpz";
        };
    };
  };

  home.packages = with pkgs; [
    sublime4
    jetbrains-mono

    # TODO remove(?)
    mdl # markdownlint
    shellcheck
    temurin-jre-bin
  ];

  xdg.mimeApps.defaultApplications = {
    "text/plain"                = "sublime_text.desktop";
    "text/tab-separated-values" = "sublime_text.desktop";
    "application/text"          = "sublime_text.desktop";
    "application/octet-stream"  = "sublime_text.desktop";
  };
}

## TODO сделать отдельный модуль для саблайма с установкой пакетов вместо Package Control

# сделать софтину аналогичную с firefox-extension,
#  которая будет по списку пакетов хэшировать последние версии из packages.io
# функция вроде sublime_with_packages [список пакетов]
# для каждого пакета нужно
#  - читать dependencies.json
#  - выбирать платформу и версию саблайма
#  - отдавать список нужных пакетов
# генерить саблайм с питон 3.8 окружением с установленными пакетами выше

# также саблайму нужно передавать
#  - настройки
#  - настройки пакетов
#  - лицензию
#  - кеймапы и синтаксисы
#  - доп пакеты
#  - что-то ещё?
