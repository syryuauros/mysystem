let

  overlay = import ./overlay {};

in import <nixpkgs> { overlays = [ overlay ]; }
