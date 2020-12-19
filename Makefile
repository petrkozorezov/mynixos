.PHONY = build switch clean
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
NRB=nixos-rebuild -v
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name

$(DIRS):
	ln -sf $(REPO_PATH) $@

build: $(DIRS)
	$(NRB) build --flake '.#'

switch: $(DIRS)
	$(NRB) switch --flake '.#'

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update-%:
	nix flake update --update-input $*

update: update-nixpkgs update-home-manager
