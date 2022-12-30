{ pkgs ? import ./pkgs.nix {}
}: pkgs.mkShell {
  NIX_CONFIG = "experimental-features = nix-command flakes";
  nativeBuildInputs = with pkgs; [
    nix
    home-manager
    deploy-rs.deploy-rs
    age
    agenix
  ];
}
