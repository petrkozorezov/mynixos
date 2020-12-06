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
    colors = {
      main = "";
      terminal = {
        primary = {
          background = "0x262626";
          foreground = "0xeaeaea";
        };
        normal = {
          black   = "0x000000";
          red     = "0xcc0403";
          green   = "0x19cb00";
          yellow  = "0xcecb00";
          blue    = "0x0d73cc";
          magenta = "0xcb1ed1";
          cyan    = "0x0dcdcd";
          white   = "0xdddddd";
        };
        bright = {
          black   = "0x767676";
          red     = "0xf2201f";
          green   = "0x23fd00";
          yellow  = "0xfffd00";
          blue    = "0x1a8fff";
          magenta = "0xfd28ff";
          cyan    = "0x14ffff";
          white   = "0xffffff";
        };
      };
    };

  };
}
