# https://github.com/cideM/solana-nix/blob/main/flake.nix
{ pkgs, ... }:
with pkgs; with llvmPackages;
rustPlatform.buildRustPackage rec {
  pname   = "solana";
  version = "1.9.2";
  src = fetchFromGitHub {
    owner  = "solana-labs";
    repo   = "solana";
    rev    = "v${version}";
    sha256 = "sha256-wrv35vBohLztMZPb6gfZdCaXcjj/Y7vnQqINaI6dBM4=";
  };
  cargoSha256 = "sha256-Qlo1rOYTu7k3N1897JK0rG/WV2Lz3rOgg5Ebr6OxRj0=";

  doCheck = false;

  LLVM_CONFIG_PATH    = "${llvm}/bin/llvm-config";
  LIBCLANG_PATH       = "${libclang.lib}/lib";
  ROCKSDB_INCLUDE_DIR = "${rocksdb_6_23}/include";
  ROCKSDB_LIB_DIR     = "${rocksdb_6_23}/lib";
  PROTOC              = "${protobuf}/bin/protoc";

  buildInputs = [
    libclang
    udev
    openssl
    zlib
  ];

  nativeBuildInputs = [
    llvm
    rustfmt
    perl
    clang
    pkg-config
    protobuf
  ];

  meta = {
    homepage    = "https://solana.com/";
    description = "Solana is a decentralized blockchain built to enable scalable, user-friendly apps for the world.";
  };
}
