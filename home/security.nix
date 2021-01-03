# useful links:
#   - https://github.com/drduh/YubiKey-Guide (also see GPGYubikey.md)
#   - https://www.passwordstore.org
#
# TODO:
#   - generate .gnupg directory
#   - generate .ssh directory
#   - programs.rofi.pass.enable = true; https://github.com/carnager/rofi-pass/
#   - https://github.com/maximbaz/yubikey-touch-detector
#   - https://github.com/palortoff/pass-extension-tail#readme
#
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

  # programs.password-store = {
  #   enable   = true;
  #   package  = pkgs.pass-wayland.withExtensions (
  #     exts: with exts; [
  #       pass-audit
  #       pass-update
  #       # (pkgs.callPackage ../overlay/pass-import.3.1.nix { })
  #     ]
  #   );
  #   # package  = pkgs.callPackage <nixpkgs>/tools/security/pass {
  #   #   waylandSupport = true;
  #   #   # pass           = pkgs.pass-wayland;
  #   #   x11Support     = false;
  #   #   wl-clipboard   = pkgs.wl-clipboard;
  #   # };
  # };

  home.file.".gnupg/scdaemon.conf".text = "reader-port Yubico Yubi";
}
