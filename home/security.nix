# useful links:
{ pkgs, ... }:
let
  gpgKey = "petr.kozorezov@gmail.com";
in {
  home.packages = with pkgs;
    [
      # yubikey
      yubikey-manager
      yubikey-personalization

      # tools
      haskellPackages.hopenpgp-tools
      pgpdump
      #pinentry-curses
      pinentry-gtk2
      paperkey
    ];

  services.gpg-agent = {
    enable           = true;
    enableSshSupport = true;
    sshKeys          = [ "1948ED036DD78C36E037A1574CE34B744329301F" ]; # keygrip
    defaultCacheTtl  = 60;
    maxCacheTtl      = 120;
    pinentryFlavor   = "gtk2";
  };
  programs.git.signing = {
    key           = gpgKey;
    signByDefault = true;
  };

  programs.password-store = {
    enable   = true;
    package  = pkgs.pass-wayland.withExtensions (
      exts: with exts; [
        pass-audit
        pass-update
      ]
    );
    settings = {
      PASSWORD_STORE_DIR = "~/.password-store";
    };
  };

  home.file.".gnupg/scdaemon.conf".text = "reader-port Yubico Yubi";
}
