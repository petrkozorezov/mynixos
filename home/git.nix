{pkgs, settings, ...}:
{
  enable    = true;
  userEmail = settings.user.email;
  userName  = settings.user.fullname;
  # signing   =
  #   {
  #     key           = settings.user.gpgKey;
  #     signByDefault = true;
  #   };
  extraConfig =
    {
      push.default = "current";
      pull.ff      = "only";
    };
}
