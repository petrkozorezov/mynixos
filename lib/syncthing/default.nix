{ slib }:
with slib.tests; addAll {
  config        = callLib ./config.nix;
  configuration = callLib ./configuration.nix;
}
