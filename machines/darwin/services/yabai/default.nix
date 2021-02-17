{ pkgs, ... }:
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;


    # Enabling this changes my background image every so second. -_-
    enableScriptingAddition = false;

    config = {

      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";

      window_placement = "second_child";
      window_topmost = "on";
      window_shadow = "float";

      window_border = "on";
      window_border_placement = "inset";
      window_border_width = 2;
      window_border_radius = 3;
      active_window_border_topmost = "off";
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
      # yabai -m space 1 --label dev
      # yabai -m space 2 --label www
      # yabai -m space 3 --label sys
      # yabai -m space 4 --label 4
      # yabai -m space 5 --label 5
      # yabai -m space 6 --label 6

      yabai -m rule --add label="Finder" app="^Finder$" title="(Co(py|nnect)|Move|Info|Pref)" manage=off
      yabai -m rule --add label="Safari" app="^Safari$" title="^(General|(Tab|Password|Website|Extension)s|AutoFill|Se(arch|curity)|Privacy|Advance)$" manage=off
      yabai -m rule --add label="KakaoTalk" app="^KakaoTalk$" manage=off
      yabai -m rule --add label="System Preferences" app="^System Preferences$" manage=off
      yabai -m rule --add label="App Store" app="^App Store$" manage=off
      yabai -m rule --add label="Activity Monitor" app="^Activity Monitor$" manage=off
      yabai -m rule --add label="KeePassXC" app="^KeePassXC$" manage=off
      yabai -m rule --add label="Calculator" app="^Calculator$" manage=off
      yabai -m rule --add label="Dictionary" app="^Dictionary$" manage=off
      yabai -m rule --add label="mpv" app="^mpv$" manage=off
      yabai -m rule --add label="The Unarchiver" app="^The Unarchiver$" manage=off

    '';
  };
}
