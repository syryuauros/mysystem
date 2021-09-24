{ pkgs }: with pkgs; let

in mkShell {
  buildInputs = with pkgs; [ deploy ];

}
