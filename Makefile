.PHONY = build switch dry-activate clean show-repo-path update-% update thinkpad-x1-extreme-gen2 image
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
NB=nix build -v
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name

$(DIRS):
	ln -sf $(REPO_PATH) $@

switch: build-mbp13
	nixos-rebuild -v switch --flake '.#mbp13'

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update-%:
	nix flake update --update-input $*

update: update-nixpkgs update-home-manager

build-%:
	$(NB) ".#$*"

deploy-%:
	nix shell -c nixops deploy -d router --include $*
