{ beam, fetchFromGitHub, tree, git, ... }:

let
  rebar3deps = beam.packages.erlang.callPackage ./rebar3deps.nix {};
in
beam.packages.erlang.rebar3Relx rec {
  name        = "erlang_ls";
  version     = "0.6.0";
  releaseType = "escript";

  src = fetchFromGitHub {
    owner  = "erlang-ls";
    repo   = name;
    rev    = version;
    sha256 = "1jwnb81p5rf4nmd2wjxcz1wmakl4gpiafb1qxfmbcmld853jf3ai";
  };

  patches = [ ./erlang_ls.patch ];

  checkouts = rebar3deps {
      inherit name version;
      src         = "${src}/rebar.lock";
      sha256      = "04bz91im3aq2l4h35ffwxg56jh8pbl0bmiwph5kwjn67c52agm20";
    };
}
