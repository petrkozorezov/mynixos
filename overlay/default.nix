self: super:
{
  overlay-sys-test = super.hello;
  overlay-hm-test  = super.hello;

  erlang_ls = super.callPackage ./erlang_ls.nix { };
  grapherl  = super.callPackage ./grapherl.nix  { };
  hamler    = super.callPackage ./hamler.nix    { };
  uhk-agent = super.callPackage ./uhk-agent.nix { };
  beam      = super.beam // {
    packages = super.beam.packages // {
      erlang = super.beam.packages.erlangR23;
    };
  };
  erlang = super.erlangR23;
}
