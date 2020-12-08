{ ... }:
{
  programs.git = {
    enable    = true;
    userEmail = "petr.kozorezov@gmail.com";
    userName  = "Petr Kozorezov";
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
  };
}
