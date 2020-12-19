{ pkgs, ... }:
let
  sublPath     = "sublime-text-3";
  packagesPath = "${sublPath}/Packages";
  userPath     = "${packagesPath}/User";
  localPath    = "${sublPath}/Local";
  installedPkgsPath = "${sublPath}/Installed Packages";
  sublSetting = {
    auto_complete                     = false;
    auto_match_enabled                = false;
    color_scheme                      = "Packages/MonokaiFree/MonokaiFree.tmTheme";
    font_face                         = "Hack";
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
  # lsp = {
  #   clients =
  #     {
  #       erlang-ls =
  #         {
  #           command    = [ "/path/to/my/erlang_ls" "--transport" "stdio" ];
  #           enabled    = true;
  #           languageId = "erlang";
  #           scopes     = [ "source.erlang" ];
  #           syntaxes   = [ "Packages/Erlang/Erlang.sublime-syntax" ];
  #         };
  #     };
  #   initialize_timeout = 30;
  #   log_debug    = false;
  #   log_server   = false;
  #   log_stderr   = false;
  #   log_payloads = false;
  # };
in
{
  # home.packages = [ pkgs.erlang_ls ];
  xdg.configFile = {
    "${userPath}/Preferences.sublime-settings".text =
      builtins.toJSON sublSetting;
    "${userPath}/Default (Linux).sublime-keymap".text =
      builtins.toJSON sublKeymap;
    # "${userPath}/LSP.sublime-settings".text =
    #   builtins.toJSON lsp;
    # TODO pass by config
    "${localPath}/License.sublime_license".source = ../secrets/sublime.license;

    # TODO remove copy/paste
    # TODO use git repo everywere
    "${packagesPath}/AlignTab".source =
      pkgs.fetchFromGitHub {
        owner  = "randy3k";
        repo   = "AlignTab";
        rev    = "st3-2.1.11";
        sha256 = "1cn56l7aivq45xx1bn0m6jjr1jabv6iicaq030h5vmbfprpkb8rf";
      };
    "${packagesPath}/Pretty JSON".source =
      pkgs.fetchFromGitHub {
        owner  = "dzhibas";
        repo   = "SublimePrettyJson";
        rev    = "st3-1.0.5";
        sha256 = "1b4sknhssmr0la67yvw5c99zklim48lgdlrwcmbl6yflvpkgng96";
      };
    "${installedPkgsPath}/Nginx.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/brandonwamboldt/sublime-nginx/archive/1.0.3.zip";
        sha256 = "09cwyjxyyjgcb8nrbvxzy80ikbrk3y18hmx2952psgyfr7mydgah";
      };
    "${installedPkgsPath}/Elixir.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/elixir-editors/elixir-tmbundle/archive/tm1.zip";
        sha256 = "1b3gvl9g7cshy62qgj99pc4440cvzj2p8yrwhs2a778sicrc8jbw";
      };
    "${installedPkgsPath}/GitGutter.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/jisaacks/GitGutter/archive/1.11.3.zip";
        sha256 = "03wl2p4ygbsdp3vplmrbqjq5fipqq852lh8k5aqmd1q7b2sl5467";
      };
    "${installedPkgsPath}/Nix.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/wmertens/sublime-nix/archive/v2.3.2.zip";
        sha256 = "1chslba5a1qb4njm99a0xjji2w85caq80n0v1m6jhmc9vx50364g";
      };
    "${packagesPath}/SublimeGit".source =
      pkgs.fetchFromGitHub {
        owner  = "SublimeGit";
        repo   = "SublimeGit";
        rev    = "1.0.37";
        sha256 = "16byz8nqljg65wb1gz1vk1fx58j9cx3ffhix6wxsmlna9g15hlwi";
      };
    "${installedPkgsPath}/SideBarEnhancements.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/titoBouzout/SideBarEnhancements/archive/5.0.39.zip";
        sha256 = "16h8j239zk8wdax6lrcq2zydlwbzd34x52za3f2jjbyh2vm4gr6m";
      };
    "${packagesPath}/Theme - Soda".source =
      pkgs.fetchFromGitHub {
        owner  = "buymeasoda";
        repo   = "soda-theme";
        rev    = "d47df56b20741eda7ada4d1ed7e730bc4203b0d3";
        sha256 = "19h7vs6zhbadsbvv20jdlj5yk1i0h892qb7dsd5xzasn05687c8h";
      };
    "${packagesPath}/MonokaiFree".source =
      pkgs.fetchFromGitHub {
        owner  = "gerardroche";
        repo   = "sublime-monokai-free";
        rev    = "1.18.10";
        sha256 = "0jdabs139x075zpbzywbz65p8wg0kr9lsxnhvywkpjkjwss1vwxw";
      };
    "${installedPkgsPath}/WordHighlight.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/SublimeText/WordHighlight/archive/ca12c7f858762428349180e8d4afe14d22ceba59.zip";
        sha256 = "1ja3vssy3375yayckg1chsx7172k0pjrly8c5nx5incfxci4a4iz";
      };
    "${installedPkgsPath}/TOML.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/jasonwilliams/sublime_toml_highlighting/archive/v2.4.0.zip";
        sha256 = "0gkxr8pa5dzhgx7hgnymd38y94achb9f56riw89i8dyag1g1z3jl";
      };
    "${installedPkgsPath}/ThriftSyntax.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/xanxys/sublime-thrift/archive/0.2.0.zip";
        sha256 = "1all2wkgvl83pkrrjw7yb05dxx3bfxylxgfrac6c6s5xmliscmii";
      };
    "${installedPkgsPath}/Protocol Buffer Syntax.sublime-package".source =
      builtins.fetchurl {
        url    = "https://github.com/vihangm/sublime-protobuf-syntax/archive/v1.3.3.zip";
        sha256 = "0zvzc0h9fc9gs1n30qhkpvgv8npmbnql1dwy8cvr624rdfdsbxxn";
      };
  };
}
