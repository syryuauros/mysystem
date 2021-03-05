{ pkgs, lib, ... }:

{

  programs.kitty = {
    enable = true;
    extraConfig = ''

      font_family      Mononoki Nerd Font
      bold_font        auto
      italic_font      auto
      bold_italic_font auto

      font_size 10.0
      background_opacity 0.95
      dynamic_background_opacity yes

      include ${./theme/tomorrow-night}
    '';

  };

}
