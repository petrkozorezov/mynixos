.PHONY = clean show-repo-path update build\:% build\:deploy installer image shell
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name
NIX_BUILD=nix build ${NIX_FLAGS} -v -L
NIX_EVAL=nix eval ${NIX_FLAGS} -v


$(DIRS):
	ln -sf $(REPO_PATH) $@

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update-ff-addons:
	cd deps/overlay && nixpkgs-firefox-addons firefox-addons.json generated-firefox-addons.nix

update-ff-userjs:
	cd home/profiles/petrkozorezov/desktop/browser && ./userjs-nix.sh > generated-userjs.nix

update-deps:
	cd deps/ && nix flake update

update-flake:
	nix flake update

update: update-ff-userjs update-ff-addons update-deps
	$(MAKU) update-flake

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

# make deploy:asrock-x300.system
deploy\:%:
	deploy -s ".#$*"

shell:
	nix shell

config.tf.json: cloud/*.nix
	terranix cloud/default.nix | jq . > $@

# make -s lib-tests:firewall | jq .command
lib-tests\:%:
	${NIX_EVAL} --json .#lib.tests.$* | jq .

# make intgr-tests:system.sss # mb with "NIX_FLAGS='--rebuild'"
intgr-tests\:%:
	$(NIX_BUILD) ".#tests.$*"

intgr-tests-interactive\:%:
	$(NIX_BUILD) ".#tests.$*.driverInteractive" && ./result/bin/nixos-test-driver --interactive

tests-all:
	$(MAKE) lib-tests:all
	$(MAKE) intgr-tests:all
