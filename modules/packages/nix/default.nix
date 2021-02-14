{ pkgs, ... } :

pkgs.symlinkJoin {
  name = "nix";
  paths = [ pkgs.nixFlakes ];
  buildInputs = [ pkgs.makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nix \
      --add-flags "--experimental-features \"nix-command flakes\""
  '';
}
