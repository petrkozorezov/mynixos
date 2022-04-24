args: let
  assertVal =
    expr: expected:
      if (expr == expected) then
        { status = "ok"; }
      else
        {
          status   = "failed";
          expected = expected;
          got      = expr;
        };
  addAll =
    tests:
      tests // (let
        subTests = (builtins.mapAttrs (_: v: if v ? tests then v.tests else {}) tests);
      in {
        tests = subTests // { all = subTests; };
      });
  callLib =
    file:
      import file (args // { inherit file slib; });

  slib = addAll {
    tests     = { inherit addAll callLib assertVal; };
    firewall  = callLib ./firewall.nix;
    syncthing = callLib ./syncthing   ;
    xml       = callLib ./xml.nix     ;
    utils     = callLib ./utils.nix   ;
  };
in slib
