{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./deriv.nix {}
