.PHONY = nixos-% hm-% clean
BASE = ${PWD}/$(dir $(lastword $(MAKEFILE_LIST)))

/etc/nixos:
	sudo ln -sf $(BASE) $@

~/.config/nixpkgs:
	ln -sf $(BASE) $@

nixos-%: /etc/nixos
	sudo nixos-rebuild $*

hm-%: ~/.config/nixpkgs
	home-manager $*

clean:
	rm -rf result
