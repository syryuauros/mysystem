#! /usr/bin/env bash

# clear ~/.config/nix/nix.conf
NIX_CONF_FILE=~/.config/nix/nix.conf
if [ -f "$NIX_CONF_FILE" ]; then
  mv $NIX_CONF_FILE $NIX_CONF_FILE.save.$(mktemp XXXX)
  echo "Moving $NIX_CONF_FILE $NIX_CONF_FILE.save.$(mktemp XXXX)"
fi


# install nix as daemon
sh <(curl -L https://nixos.org/nix/install) --daemon


# install nix-flake
nix-env -iA nixpkgs.nixFlakes


# install nix-darwin
nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
./result/bin/darwin-installer

# reopen the shell
