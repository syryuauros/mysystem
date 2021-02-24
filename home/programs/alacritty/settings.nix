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

  # colors = import ./theme/doom-one;
  colors = import ./theme/tomorrow-night;

}
