{ config, pkgs, nix-doom-emacs, ... }:
let
  term = "TERM=xterm-24bit";
in {
  imports = [
    nix-doom-emacs.hmModule
  ];

  home.sessionVariables.EDITOR = "${term} emacsclient";
  programs.doom-emacs = {
    enable               = true;
    doomPrivateDir       = ./emacs;
    emacsPackage         = pkgs.emacs-nox;
    emacsPackagesOverlay = self: super: {
      xclip = super.xclip.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.wl-clipboard-x11 ];
      });
      lsp-mode = super.lsp-mode.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.erlang-ls ];
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
    xterm-24bit
  ];

  services.emacs = {
    enable                  = true;
    socketActivation.enable = true;
  };

  programs.zsh.shellAliases = { "emacs" = "${term} emacs"; "emacsclient" = "${term} emacsclient"; };
}
