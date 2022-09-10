{ pkgs ? let flake = builtins.getFlake (toString ./.);
         in import flake.inputs.nixpkgs { overlays = [ flake.overlay ]; }
}: pkgs.mkShell {
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    git
    deploy-rs.deploy-rs
    age
  ];
}
