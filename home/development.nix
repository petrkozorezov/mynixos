{ pkgs, ... }:
{
  home = {
    packages = with pkgs;
      [
        # general tools
        gnumake
        gcc
        sublime3

        # erlang
        erlang
        rebar3

        # nix dev tools
        nix-prefetch-git
        cachix

        # coq
        coq_8_13
        coqPackages.mathcomp-ssreflect
        coqPackages.mathcomp-solvable
        coqPackages.mathcomp-real-closed
        coqPackages.mathcomp-finmap
        coqPackages.mathcomp-fingroup
        coqPackages.mathcomp-field
        coqPackages.mathcomp-character
        coqPackages.mathcomp-bigenough
        coqPackages.mathcomp-analysis
        coqPackages.mathcomp-algebra
        coqPackages.mathcomp

        # misc
        cloc
        gtypist
        grapherl
        pandoc
      ];

    sessionVariables.COQPATH = "/etc/profiles/per-user/petrkozorezov/lib/coq/8.11/user-contrib"; # FIXME
  };
}
