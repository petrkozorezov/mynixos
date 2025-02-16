NIX_BUILD?=nix build $(NIX_FLAGS) -v -L # --show-trace
NIX_EVAL?=nix eval $(NIX_FLAGS) -v
HOSTNAME?=$(shell hostname)
USERNAME?=$(shell whoami)

clean:
	rm -rf result

update-deps:
	cd deps/ && nix flake update

update-flake:
	cd deps/ && nix flake info > /dev/null
	nix flake update

update:
	$(MAKE) update-deps
	$(MAKE) update-flake

# make nixos-rebuild:switch
# make nixos-rebuild:build
# make nixos-rebuild:build-vm
# make nixos-rebuild:build-vm HOSTNAME=mbp13
nixos-rebuild\:%:
	nixos-rebuild --flake .#$(HOSTNAME) $*

# make home-manager:build
# TODO test
home-manager\:%:
	home-manager --flake .#$(HOSTNAME).$(USERNAME) $*

QEMU_OPTS?=-m 8192 -smp 4 -device virtio-gpu-pci -display sdl,gl=on -device virtio-balloon-pci
run-vm: nixos-rebuild\:build-vm
	./result/bin/run-$(HOSTNAME)-vm $(QEMU_OPTS)

PROFILE?=system
DEPLOY_FLAGS?=-s
DEPLOY?=deploy $(DEPLOY_FLAGS)
# make deploy
# make deploy HOSTNAME=asrock-x300
# make deploy HOSTNAME=asrock-x300 PROFILE=petrkozorezov
deploy\:%:
	$(DEPLOY) -s ".#$(HOSTNAME).$(PROFILE)"

TEST?=all
# make -s lib-tests TEST=all | jq '.[][].status'
# make -s lib-tests TEST=firewall | jq .command
# make -s lib-tests TEST=firewall.command
lib-tests:
	# TODO fail!!!
	$(NIX_EVAL) --json ".#lib.tests.$(TEST)" | jq .

# make intgr-tests
# make intgr-tests TEST=system.sss
# mb with "NIX_FLAGS='--rebuild'" (does not work with all target)
intgr-tests:
	$(NIX_BUILD) ".#tests.$(TEST)"

# BROKEN
# intgr-tests-interactive:
# 	$(NIX_BUILD) ".#tests.$(TEST).driverInteractive" && ./result/bin/nixos-test-driver --interactive

HOSTS=asrock-x300 mbp13 srv1 # router
ci-all-hosts\:%:
	@for HOST in $(HOSTS); do \
		$(MAKE) "$*" HOSTNAME="$$HOST" || exit 1; \
	done

# TODO ci:
# - for all hosts
#   - nixos-rebuild build-image
#   - load vm
# - for all users
#   - home-manager bulid
ci:
	$(MAKE) lib-tests TEST=all
	$(MAKE) intgr-tests TEST=all
	$(MAKE) ci-all-hosts:nixos-rebuild:build
	$(MAKE) ci-all-hosts:nixos-rebuild:build-vm
