{ pkgs, lib, ... }: {

  programs.alacritty = {
    enable = true;
    settings = lib.attrsets.recursiveUpdate
      (pkgs.myImport ./settings.nix {}) {
      font.size = 11;
      font.user_thin_strokes = false;
      window = {
        decorations = "full";
      };
    };
  };

}
