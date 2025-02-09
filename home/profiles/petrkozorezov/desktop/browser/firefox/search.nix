{ pkgs, ... }: {
  default        = "DuckDuckGo";
  privateDefault = "DuckDuckGo";
  force          = true;
  order          = [ "DuckDuckGo" "Google" "Yandex" "Wikipedia (en)" ]; # TODO
  engines = {
    "DuckDuckGo".metaData.alias     = ".d";
    "Google".metaData.alias         = ".g";
    "Yandex".metaData.alias         = ".y";
    "Wikipedia (en)".metaData.alias = ".w";
    "Amazon.com".metaData.hidden    = true;
    "Bing".metaData.hidden          = true;

    "Nix Packages" = {
      urls = [{
        template = "https://search.nixos.org/packages";
        params = [
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ ".nsp" ];
    };

    "NixOS Options" = {
      urls = [{
        template = "https://search.nixos.org/options";
        params = [
          { name = "query"; value = "{searchTerms}"; }
        ];
      }];

      icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
      definedAliases = [ ".nso" ];
    };

    "NixOS Wiki" = {
      urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
      iconUpdateURL = "https://nixos.wiki/favicon.png";
      updateInterval = 24 * 60 * 60 * 1000; # every day
      definedAliases = [ ".nsw" ];
    };

    "HexDocs" = {
      urls = [{ template = "https://hexdocs.pm/{searchTerms}"; }];
      # TODO icon
      definedAliases = [ ".hd" ];
    };

    "HexDocs Elixir" = {
      urls = [{
        template = "https://hexdocs.pm/elixir/search.html";
        params = [{ name = "q"; value = "{searchTerms}"; }];
      }];
      # TODO icon
      definedAliases = [ ".hde" ];
    };

    # TODO add google/yandex translate (gt/yt) and mb chatgpt, noogle.dev (noo), home-manager (nhm) (where?)
  };
}
