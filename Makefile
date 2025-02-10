.PHONY = clean show-repo-path update build\:% build\:deploy installer image shell
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))
DIRS=/etc/nixos ~/.config/nixpkgs # FIXME better name
NIX_BUILD=nix build ${NIX_FLAGS} -v -L # --show-trace
NIX_EVAL=nix eval ${NIX_FLAGS} -v


$(DIRS):
	ln -sf $(REPO_PATH) $@

clean:
	rm -rf result

show-repo-path:
	@echo $(REPO_PATH)

update-deps:
	cd deps/ && nix flake update

update-flake:
	cd deps/ && nix flake info > /dev/null
	nix flake update

update: update-deps
	$(MAKE) update-flake

# make build:system:mbp13
build\:system\:%:
	# or `build:deploy.nodes.$*.profiles.system.path`
	$(MAKE) build:configs.$*.profiles.system.config.system.build.toplevel

# make build:hm:mbp13.profiles.petrkozorezov
build\:hm\:%:
	$(MAKE) build:configs.$*.activationPackage

# BROKEN
# make build:image:installer
# build\:image\:%:
# 	$(MAKE) build:configs.$*.config.system.build.isoImage

build\:%:
	$(NIX_BUILD) ".#$*"

# make deploy:asrock-x300.system
# make deploy:asrock-x300.petrkozorezov
deploy\:%:
	deploy -s ".#$*"

shell:
	nix develop --impure

config.tf.json: cloud/*.nix
	terranix cloud/default.nix | jq . > $@

# TODO tf-init/plan/apply/destroy

# make -s lib-tests:all | jq '.[][].status'
# make -s lib-tests:firewall | jq .command
# make -s lib-tests:firewall.command
lib-tests\:%:
	${NIX_EVAL} --json .#lib.tests.$* | jq .

# make intgr-tests:all
# make intgr-tests:system.sss
# mb with "NIX_FLAGS='--rebuild'" (does not work with all target)
intgr-tests\:%:
	$(NIX_BUILD) ".#tests.$*"

# BROKEN
# intgr-tests-interactive\:%:
# 	$(NIX_BUILD) ".#tests.$*.driverInteractive" && ./result/bin/nixos-test-driver --interactive

tests-all:
	$(MAKE) lib-tests:all
	$(MAKE) intgr-tests:all
