{ inputs ?
  let flake = builtins.getFlake (toString ./.);
  in flake.inputs
, system ? builtins.currentSystem
, overlays ? []
}:
let
  inherit (inputs) nixpkgs deploy-rs;
in
import nixpkgs {
  inherit system;
  overlays = [ deploy-rs.overlay ] ++ overlays;
}
