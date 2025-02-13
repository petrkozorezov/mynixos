{ pkgs, ... }: {
  default        = "DuckDuckGo";
  privateDefault = "DuckDuckGo";
  force          = true;
  order          = [ "DuckDuckGo" "Google" "Yandex" "Wikipedia (en)" ]; # TODO
  engines = let
    engine = { domain, path, alias, params ? [], favext ? "png", favicon ? "favicon.${favext}" }: {
      urls = [{ template = "https://${domain}/${path}"; inherit params; }];
      updateInterval = 30 * 24 * 60 * 60 * 1000; # every month
      iconUpdateURL = "https://${domain}/${favicon}";
      definedAliases = [ alias ];
    };

  in {
    "DuckDuckGo".metaData.alias = ".d";
    "DuckDuckGo onion" = engine {
      alias  = ".ddgo";
      domain = "duckduckgogg42xjoc72x3sjasowoarfbgcmvfimaftt6twagswzczad.onion";
      path   = "?t=h_&q=test&ia=web";
    };

    # FIX icon
    "Google".metaData.alias = ".g";
    "Google translate to Ru" = engine {
      alias  = ".gtr";
      domain = "translate.google.com";
      path   = "?sl=auto&tl=ru&text={searchTerms}&op=translate";
      favext = "ico";
    };
    "Google translate to En" = engine {
      alias  = ".gte";
      domain = "translate.google.com";
      path   = "?sl=auto&tl=en&text={searchTerms}&op=translate";
      favext = "ico";
    };

    # FIX icon
    "Yandex translate to Ru" = engine {
      alias  = ".ytr";
      domain = "translate.yandex.ru";
      path   = "?source_lang=en&target_lang=ru&text={searchTerms}";
      favicon = "icons/favicon.ico";
    };
    "Yandex translate to En" = engine {
      alias  = ".yte";
      domain = "translate.yandex.ru";
      path   = "?source_lang=ru&target_lang=en&text={searchTerms}";
      favicon = "icons/favicon.ico";
    };

    "Wikipedia (en)".metaData.alias = ".w";
    "Amazon.com".metaData.hidden    = true;
    "Bing".metaData.hidden          = true;

    "Nix Packages" = engine {
      alias  = ".nsp";
      domain = "search.nixos.org";
      path   = "packages";
      params = [
        { name = "query"; value = "{searchTerms}"; }
      ];
    };
    "NixOS Options" = engine {
      alias  = ".nso";
      domain = "search.nixos.org";
      path   = "options";
      params = [
        { name = "query"; value = "{searchTerms}"; }
      ];
    };
    # FIX icon
    "NixOS Wiki" = engine {
      alias  = ".nsw";
      domain = "nixos.wiki";
      path   = "index.php?search={searchTerms}";
    };
    "Noogle" = engine {
      alias  = ".noo";
      domain = "noogle.dev";
      path   = "q?term={searchTerms}";
    };
    # Homemanager
    "HomeManager" = engine {
      alias   = ".hmo";
      domain  = "home-manager-options.extranix.com";
      path    = "?query={searchTerms}&release=master";
      favicon = "images/favicon.png";
    };

    "HexDocs" = engine {
      alias  = ".hd";
      domain = "hexdocs.pm";
      path   = "{searchTerms}";
    };
    "HexDocs Elixir" = engine {
      alias  = ".hde";
      domain = "hexdocs.pm";
      path   = "elixir/search.html";
      params = [{ name = "q"; value = "{searchTerms}"; }];
    };

    "GitHub" = engine {
      alias  = ".gh";
      domain = "github.com";
      path   = "search?q={searchTerms}&type=repositories";
      favext = "ico";
    };
  };
}
