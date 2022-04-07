{ pkgs, ... }: {
  programs.firefox.extensions = [ pkgs.firefox-addons.passff ];

  home.file = let
    userPath = ".mozilla/native-messaging-hosts";
    pkgsPath = "${pkgs.passff-host}/lib/mozilla/native-messaging-hosts";
  in {
    "${userPath}/passff.json".source = "${pkgsPath}/passff.json";
    "${userPath}/passff.py".source   = "${pkgsPath}/passff.py"  ;
  };
}
