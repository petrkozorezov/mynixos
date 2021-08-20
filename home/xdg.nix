{ pkgs, ... }:
{
  xdg = {
    # TODO
    # https://wiki.archlinux.org/title/Default%20applicationsq
    # mimeo --mimeapps-list
    # mimeApps = {
    #   enable = true;

    #   defaultApplications = {};
    # };
    # userDirs = {
    #   enable = true;
    #   createDirectories = true;
    # };
  };

  home.packages = with pkgs; [ xdg_utils mimeo ];
}
