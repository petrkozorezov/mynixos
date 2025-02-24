{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[λ](bold green)";
        error_symbol   = "[λ](bold red)";
      };
      erlang = { disabled = true; };
      elixir = { disabled = true; };
    };
  };
}
