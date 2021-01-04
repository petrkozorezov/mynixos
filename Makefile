.PHONY = build switch clean
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
NB=nix build -v
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name

$(DIRS):
	ln -sf $(REPO_PATH) $@

switch: thinkpad-x1-extreme-gen2
	./result/bin/switch-to-configuration switch

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update-%:
	nix flake update --update-input $*

update: update-nixpkgs update-home-manager

thinkpad-x1-extreme-gen2: $(DIRS)
	$(NB) '.#thinkpad-x1-extreme-gen2'

image:
	$(NB) ".#image"
