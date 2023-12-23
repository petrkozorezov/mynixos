{ pkgs, deps, system, ... }:
{
  home = {
    packages = with pkgs;
      [
        gtypist
        # grapherl
        pandoc
        # solana

        cachix
        deps.inputs.devenv.packages.${system}.devenv
        gnumake
      ];

    sessionVariables.COQPATH = "/etc/profiles/per-user/petrkozorezov/lib/coq/8.13/user-contrib"; # FIXME
  };

  nix.settings = {
    substituters        = [ "https://devenv.cachix.org" ];
    trusted-public-keys = [ "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" ];
  };
}

# TODO move somewhere
# coq
# coq_8_13
# coqPackages_8_13.mathcomp-ssreflect
# coqPackages_8_13.mathcomp-solvable
# coqPackages_8_13.mathcomp-real-closed
# coqPackages_8_13.mathcomp-finmap
# coqPackages_8_13.mathcomp-fingroup
# coqPackages_8_13.mathcomp-field
# coqPackages_8_13.mathcomp-character
# coqPackages_8_13.mathcomp-bigenough
# coqPackages_8_13.mathcomp-analysis
# coqPackages_8_13.mathcomp-algebra
# coqPackages_8_13.mathcomp

