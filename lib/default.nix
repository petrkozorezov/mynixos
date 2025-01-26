args: let
  collectTests =
    tests:
      tests // (let
        subTests = (builtins.mapAttrs (_: v: if v ? tests then v.tests else {}) tests);
      in {
        tests = subTests // { all = subTests; };
      });
  callLib =
    file:
      import file (args // { inherit file slib; });

  slib = collectTests {
    testing   = callLib ./testing.nix ;
    firewall  = callLib ./firewall.nix;
    xml       = callLib ./xml.nix     ;
    utils     = callLib ./utils.nix   ;
  };
in slib
