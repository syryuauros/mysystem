{ fish, neofetch } :
{
  env = {
    "TERM" = "xterm-256color";
  };

  background_opacity = 0.95;

  selection.save_to_clipboard = true;

  window = {
    padding.x = 10;
    padding.y = 10;
    decorations = "buttonless";
  };

  bell = {
    animation = "EaseOutExpo";
    duration = 5;
    color = "#ffffff";
  };

  font = {
    size = 12.0;
    use_thin_strokes = true;

    normal.family = "Mononoki Nerd Font";
    bold.family = "Mononoki Nerd Font";
    italic.family = "Mononoki Nerd Font";
  };

  cursor.style = "Beam";

  shell = {
    program = "${fish}/bin/fish";
    args = [
      "-C"
      "${neofetch}/bin/neofetch"
    ];
  };

  colors = {
    # Default colors
    primary = {
      background = "0x1b182c";
      foreground = "0xcbe3e7";
    };

    # Normal colors
    normal = {
      black =   "0x100e23";
      red =     "0xff8080";
      green =   "0x95ffa4";
      yellow =  "0xffe9aa";
      blue =    "0x91ddff";
      magenta = "0xc991e1";
      cyan =    "0xaaffe4";
      white =   "0xcbe3e7";
    };

    # Bright colors
    bright = {
      black =   "0x565575";
      red =     "0xff5458";
      green =   "0x62d196";
      yellow =  "0xffb378";
      blue =    "0x65b2ff";
      magenta = "0x906cff";
      cyan =    "0x63f2f1";
      white = "0xa6b3cc";
    };
  };
}
