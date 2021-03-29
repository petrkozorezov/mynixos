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
        coqPackages_8_13.mathcomp-ssreflect
        coqPackages_8_13.mathcomp-solvable
        coqPackages_8_13.mathcomp-real-closed
        coqPackages_8_13.mathcomp-finmap
        coqPackages_8_13.mathcomp-fingroup
        coqPackages_8_13.mathcomp-field
        coqPackages_8_13.mathcomp-character
        coqPackages_8_13.mathcomp-bigenough
        coqPackages_8_13.mathcomp-analysis
        coqPackages_8_13.mathcomp-algebra
        # coqPackages_8_13.mathcomp

        # misc
        cloc
        gtypist
        grapherl
        pandoc
      ];

    sessionVariables.COQPATH = "/etc/profiles/per-user/petrkozorezov/lib/coq/8.13/user-contrib"; # FIXME
  };
}
