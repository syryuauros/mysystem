{ pkgs, lib, ... }:
{

  programs.alacritty = {

    enable = true;

    settings = lib.attrsets.recursiveUpdate
      (import ./settings.nix { inherit (pkgs) fish neofetch; }) {
      font.size = 11;
      font.user_thin_strokes = false;
      window = {
        decorations = "full";
      };
    };

  };

}
