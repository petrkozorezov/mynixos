# https://nixos.wiki/wiki/Yubikey
{ config, pkgs, lib, ... }: {
  home.packages = with pkgs;
    [
      # tools
      haskellPackages.hopenpgp-tools
      pgpdump
      paperkey
    ];

  # gpg
  programs.pinentry.enable = true;
  services.gpg-agent = {
    enable           = true;
    enableSshSupport = true;
    sshKeys          = [ "1948ED036DD78C36E037A1574CE34B744329301F" ]; # keygrip
    defaultCacheTtl  = 60;
    maxCacheTtl      = 120;
    pinentryFlavor   = lib.mkDefault "curses";
  };
  # TODO
  # home.file.".gnupg/".mode = "700";
  home.file.".gnupg/pubring.kbx".source = config.zoo.secrets.filesPath + "/gnupg.pubring.kbx";
  home.file.".gnupg/scdaemon.conf".text = "disable-ccid";
  home.file.".ssh/id_rsa_ybk1.pub".text = config.zoo.secrets.users.petrkozorezov.authPublicKey;

  # add card auto-insertion before commit
  # TODO add programs.git.hooks
  programs.git.extraConfig.core.hooksPath = "${config.xdg.configHome}/git/hooks";
  home.file."${config.xdg.configHome}/git/hooks/pre-commit" = {
    executable = true;
    text       = "gpg --card-status";
  };

  programs.password-store = {
    enable  = true;
    package = pkgs.pass.withExtensions (
      exts: with exts; [
        pass-audit
        pass-update
      ]
    );
    settings = {
      PASSWORD_STORE_DIR = "${config.home.homeDirectory}/.password-store/";
    };
  };
}
