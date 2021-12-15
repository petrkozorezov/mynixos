.PHONY = clean show-repo-path update build\:% build\:deploy installer image shell
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name
NIX_BUILD=nix build ${NIX_BUILD_FLAGS} -v


$(DIRS):
	ln -sf $(REPO_PATH) $@

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update:
	nix flake update
	cd home/profiles/petrkozorezov/browser && ./userjs-nix.sh > generated-userjs.nix
	cd overlay && nixpkgs-firefox-addons firefox-addons.json generated-firefox-addons.nix

# make build:system:mbp13
build\:system\:%:
	# or `build:deploy.nodes.$*.profiles.system.path`
	$(MAKE) build:configs.$*.system.config.system.build.toplevel

# make build:user:mbp13.petrkozorezov
build\:user\:%:
	$(MAKE) build:configs.$*.activationPackage

# make build:image:installer
# build\:image\:%:
# 	$(MAKE) build:configs.$*.config.system.build.isoImage

build\:%:
	$(NIX_BUILD) ".#$*"

deploy\:%:
	deploy -s ".#$*"

shell:
	nix shell

config.tf.json: cloud/*.nix
	terranix cloud/default.nix | jq . > $@

# NIX_BUILD_FLAGS='--rebuild' make tests:system.sss
tests\:%:
	$(NIX_BUILD) ".#tests.$*"

tests-interactive\:%:
	$(NIX_BUILD) ".#tests.$*.driverInteractive" && ./result/bin/nixos-test-driver --interactive
