{ pkgs }: with pkgs; let

in mkShell {
  buildInputs = with pkgs; [ deploy-rs.deploy-rs ];
}
