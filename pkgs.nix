{ inputs ?
  let flake = builtins.getFlake (toString ./.);
  in flake.inputs
, system ? builtins.currentSystem
, overlays ? []
}:
let
  inherit (inputs) nixpkgs deploy-rs agenix;
in
import nixpkgs {
  inherit system;
  overlays = [
    deploy-rs.overlay
    agenix.overlay
    (final: prve: { xmonad-restart = inputs.myxmonad.packages.${system}.xmonad-restart; })
  ] ++ overlays;
}
