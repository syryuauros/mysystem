{ pkgs ? import <nixpkgs> { overlays = [ (import ./overlay.nix) ]; } }:

pkgs.mkShell {
  buildInputs =  [ pkgs.myvim ];
}
