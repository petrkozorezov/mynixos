{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    yubikey-manager
    yubikey-personalization
    yubioath-desktop
  ];
  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

  # pam login with otp
  # security.pam.yubico = {
  #   enable  = true;
  #   debug   = true;
  #   mode    = "challenge-response";
  #   control = "required";
  # };

  # TODO
  # pam login with u2f
  # pamu2fcfg -uusername -opam://myorigin -ipam://myappid
  # pamu2fcfg -upetr.kozorezov -opam://kozorezov.ru -ipam://u2f_login
  # u2f_mappings = writeFile u2f_mappings ''

  # '';
  # security.pam.u2f = {
  #   enable   = true;
  #   authFile = u2f_mappings;
  #   appId    = "u2f_login";
  #   cue      = true;
  # };
}
