{ config, pkgs, nix-doom-emacs, ... }:
{
  imports = [
    nix-doom-emacs.hmModule
  ];

  home.sessionVariables.EDITOR = "emacsclient";
  programs.doom-emacs = {
    enable         = true;
    doomPrivateDir = ./emacs;
    emacsPackage   = pkgs.emacs-nox;
    emacsPackagesOverlay = self: super: {
       xclip = super.xclip.overrideAttrs (esuper: {
         buildInputs = esuper.buildInputs ++ [ pkgs.wl-clipboard-x11 ];
       });
       lsp-mode = super.lsp-mode.overrideAttrs (esuper: {
         buildInputs = esuper.buildInputs ++ [ pkgs.erlang_ls ];
       });
    };
  };

  home.packages = with pkgs; [
    # https://github.com/hlissner/doom-emacs/blob/develop/docs/getting_started.org#nixos
    git
    ripgrep
    fd
    coreutils
    # clang
  ];

  services.emacs = {
    enable                  = true;
    socketActivation.enable = true;
    package                 = config.programs.emacs.package;
  };
}
