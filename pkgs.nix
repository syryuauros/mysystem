{ inputs ?
  let flake = builtins.getFlake (toString ./.);
  in flake.inputs
, system ? builtins.currentSystem
}:
let
  inherit (inputs) nixpkgs deploy-rs;
in
import nixpkgs {
  inherit system;
  overlays = [ deploy-rs.overlay ];
}
