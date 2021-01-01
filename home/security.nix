{ pkgs, ... }:
{
  # https://github.com/drduh/YubiKey-Guide
  home.packages = with pkgs;
    [
      # yubikey
      yubikey-manager
      # yubikey-manager-qt
      yubikey-personalization

      # tools
      haskellPackages.hopenpgp-tools

      pgpdump

    ];

  services.gpg-agent = {
    enable = true;
    # enableSshSupport = true;
    # sshKeys = [ "" ]
    # pinentryFlavor = "gtk2";
    # extraConfig = "";
  };
  programs.git.signing = {
    key           = "EF2A246DDE509B0C";
    signByDefault = true;
  };
  # TODO echo "reader-port Yubico Yubi" >> .gnupg/scdaemon.conf

  # # https://www.passwordstore.org
  # programs.password-store = {
  #   enable   = true;
  #   package  = pkgs.pass-wayland;
  #   settings =
  #     {
  #       PASSWORD_STORE_DIR              = ".passwd/";
  #       PASSWORD_STORE_KEY              = "12345678";
  #       PASSWORD_STORE_CLIP_TIME        = "60";
  #       PASSWORD_STORE_GENERATED_LENGTH = "12";
  #     };
  # };

  # # # https://www.passwordstore.org
  # home.packages = with pkgs.passExtensions;
  #   [
  #     pass-audit
  #     pass-tomb
  #     pass-import
  #     pass-update
  #     pass-checkup
  #     pass-genphrase
  #     pass-otp
  #   ];

  # # https://github.com/carnager/rofi-pass/
  # # programs.rofi.pass.enable = true;

}
