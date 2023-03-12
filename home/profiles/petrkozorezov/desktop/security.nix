{ pkgs, ... }:
{
  home.packages = with pkgs;
    [
      wl-clipboard
    ];

  # TODO pinentry-rofi
  programs.pinentry.package = pkgs.pinentry-gtk2;
  services.gpg-agent.pinentryFlavor = "gtk2";

  programs.zsh.initExtra =
    # TODO pass init
    ''
      pc() {
        gpg --card-status > /dev/null
        pass show $1 | head -n 1 | tr -d '\n' | wl-copy
      }
    '';
}
