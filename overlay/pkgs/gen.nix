config:
{
  xdg.configFile."mako/config1" = {
    text =
      replaceStrings [ "\\\\" ] [ "\\" ] (builtins.toJSON cfg.settings);
  };
}
