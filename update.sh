#! /bin/sh
nix-channel --update
nixos-rebuild switch
#vulnix --system
# nixos-rebuild switch --upgrade
#
dconf write /org/gnome/nautilus/preferences/always-use-location-entry true
nix-collect-garbage --delete-older-than 7d

