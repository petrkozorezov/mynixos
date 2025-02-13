{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      wl-clipboard
    ];

  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs.zsh.initExtra =
    # TODO pass init
    ''
      pc() {
        gpg --card-status > /dev/null
        pass show $1 | head -n 1 | tr -d '\n' | wl-copy
      }
    '';
}
