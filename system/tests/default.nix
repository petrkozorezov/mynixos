{ runTest, addTestAll, ... }: addTestAll {
  forwarding = runTest ./forwarding.nix;
  sss        = runTest ./sss.nix       ;
  vpn        = runTest ./vpn.nix       ;
}
