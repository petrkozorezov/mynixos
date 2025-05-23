{ pkgs, ... }: {
  services.gpg-agent.pinentry.package = pkgs.pinentry-qt;

  programs.zsh.initContent = ''
    pc() {
      gpg --card-status > /dev/null
      pass show $1 | head -n 1 | tr -d '\n' | ${pkgs.wl-clipboard}/bin/wl-copy
    }
  '';
}
