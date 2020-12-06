let
  nur_repo = builtins.fetchTarball {
    url    = "https://github.com/nix-community/NUR/archive/1a65739939b6d5e5f3b40f9fc51f4362720478c1.tar.gz";
    sha256 = "1r32qv3kfq4c3gc5cnrbscghxp891sdn6i042kd4msx133iawp5q";
  };
in {
  allowUnfree = true;
  permittedInsecurePackages = [
    "openssl-1.0.2u"
    "python2.7-cryptography-2.9.2"
  ];

  packageOverrides = pkgs: {
    nur = import (nur_repo) { inherit pkgs; };
  };
}
