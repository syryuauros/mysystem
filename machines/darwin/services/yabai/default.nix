{ pkgs, ... }:
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;


    # Enabling this changes my background image every so second. -_-
    enableScriptingAddition = false;

    config = {

      focus_follows_mouse = "off"; # "autoraise";
      mouse_follows_focus = "off";

      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "float";

      window_border = "on";
      window_border_placement = "inset";
      window_border_width = 2;
      window_border_radius = 3;
      active_window_border_topmost = "on";
      active_window_border_color = "0xff5c7e81";
      normal_window_border_color = "0xff505050";
      insert_window_border_color = "0xffd75f5f";

      window_opacity = "on";
      window_opacity_duration = "0.0";
      active_window_opacity = "0.95";
      normal_window_opacity = "0.90";

      split_ratio = "0.50";
      auto_balance = "off";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";

      layout = "bsp";

      top_padding = 10;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;

    };

    extraConfig = ''

      # mission-control desktop labels
      yabai -m space 1 --label dev
      yabai -m space 2 --label www
      yabai -m space 3 --label sys
      yabai -m space 4 --label 4
      yabai -m space 5 --label 5
      yabai -m space 6 --label 6
      yabai -m space 7 --label 7
      yabai -m space 8 --label 8
      yabai -m space 9 --label 0

      yabai -m rule --add app!="^(Safari|Emacs|alacritty)$" manage=off

    '';
  };
}
