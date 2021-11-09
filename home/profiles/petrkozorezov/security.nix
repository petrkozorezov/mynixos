# useful links:
{ config, pkgs, ... }:
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

      # for pass copy alias (pc)
      wl-clipboard
    ];

  # gpg
  services.gpg-agent = {
    enable           = true;
    enableSshSupport = true;
    sshKeys          = [ "1948ED036DD78C36E037A1574CE34B744329301F" ]; # keygrip
    defaultCacheTtl  = 60;
    maxCacheTtl      = 120;
    pinentryFlavor   = "gtk2";
  };
  # TODO
  # home.file.".gnupg/".mode = "700";
  home.file.".gnupg/pubring.kbx".source = config.zoo.secrets.filesPath + "/gnupg.pubring.kbx";
  home.file.".gnupg/scdaemon.conf".text = "reader-port Yubico Yubi";
  home.file.".ssh/id_rsa_ybk1.pub".text = config.zoo.secrets.users.petrkozorezov.authPublicKey;

  # add card auto-insertion before commit
  # TODO add programs.git.hooks
  programs.git.extraConfig.core.hooksPath = "${config.xdg.configHome}/git/hooks";
  home.file."${config.xdg.configHome}/git/hooks/pre-commit" = {
    executable = true;
    text       = "gpg --card-status";
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
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store/";
    };
  };
  programs.zsh.initExtra =
    ''
      pc() {
        gpg --card-status > /dev/null
        pass show $1 | head -n 1 | tr -d '\n' | wl-copy
      }
    '';

}
