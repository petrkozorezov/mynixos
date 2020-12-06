{settings, ...}:
{
  enable = true;
  settings =
    {
      scrolling =
        {
          history         = 10000;
          multiplier      = 30;
        };
      font =
        {
          normal.family = settings.style.font;
          size = 13.0;
        };
      background_opacity = 0.99;
      colors = settings.style.colors.terminal;
    };
}
