# TODO make wTests more general
args: let
  wTests =
    tests:
      tests // (let
        subTests = (builtins.mapAttrs (_: v: if v ? tests then v.tests else {}) tests);
      in {
        tests = subTests // {
          all = subTests;
        };
      });
in wTests {
  firewall = import ./firewall.nix args;
}
