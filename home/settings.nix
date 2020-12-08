{
  user = rec {
    login     = "petr.kozorezov";
    email     = "${login}@gmail.com";
    firstname = "Petr";
    lastname  = "Kozorezov";
    fullname  = "${firstname} ${lastname}";
    gpgKey    = "EF2A246DDE509B0C";
  };
  terminal = "alacritty";
  style = {
    font = "Hack";
  };
}
