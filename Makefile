.PHONY = nixos-% hm-% clean
REPO_PATH = `pwd`/$(dir $(lastword $(MAKEFILE_LIST)))

/etc/nixos ~/.config/nixpkgs:
	ln -sf $(REPO_PATH) $@

nixos-%: /etc/nixos
	nixos-rebuild $*

hm-%: ~/.config/nixpkgs
	home-manager $*

clean:
	rm -rf result

build: hm-build nixos-build

show-repo-path:
	@echo $(REPO_PATH)
