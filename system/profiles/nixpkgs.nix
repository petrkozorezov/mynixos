{ inputs, ... }: {
  nixpkgs =
    {
      config = {
        allowUnfree = true;
        permittedInsecurePackages = [
          "openssl-1.0.2u"
          "python2.7-cryptography-2.9.2"
        ];
      };

      overlays = [ (import ../../overlay) inputs.nur.overlay ];
    };
}