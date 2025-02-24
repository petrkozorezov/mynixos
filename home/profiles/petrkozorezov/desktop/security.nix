{ pkgs, ... }: {
  services.gpg-agent.pinentryPackage = pkgs.pinentry-qt;

  programs.zsh.initExtra = ''
    pc() {
      gpg --card-status > /dev/null
      pass show $1 | head -n 1 | tr -d '\n' | ${pkgs.wl-clipboard}/bin/wl-copy
    }
  '';
}
