.PHONY = clean show-repo-path update build\:% build\:deploy installer image
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name

$(DIRS):
	ln -sf $(REPO_PATH) $@

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

#TODO update\:%

update:
	nix flake update

build\:%:
	nix build -v ".#$*"

deploy\:%:
	deploy -s ".#$*"

shell:
	nix shell

build\:nixos\:%:
	$(MAKE) build:nixosConfigurations.$*.config.system.build.toplevel

build\:image\:%:
	$(MAKE) build:nixosConfigurations.$*.config.system.build.isoImage

config.tf.json: cloud/*.nix
	terranix cloud/default.nix | jq . > $@
