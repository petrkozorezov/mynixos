config:
{
  xdg.configFile."mako/config" = {
    text =
      replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg.settings);
  };
}
