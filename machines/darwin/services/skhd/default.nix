{
  services.skhd = {
    enable = true;
    skhdConfig = ''
      # launchers
      shift + ctrl + alt - e: open ~/.nix-profile/Applications/Emacs.app
      shift + ctrl + alt - return : open ~/.nix-profile/Applications/Alacritty.app
      shift + ctrl + alt - v: osascript -e 'tell application "Viscosity" to connect "work"'
      # focus window
      alt - left: yabai -m window --focus west
                   alt - down : yabai -m window --focus south || yabai -m display --focus prev
                   alt - up : yabai -m window --focus north || yabai -m display --focus next
                   alt - right : yabai -m window --focus east
                   # shift window in current workspace, use the arrow keys
                   alt + shift - left  : yabai -m window --warp west
                   alt + shift - down  : yabai -m window --warp south
                   alt + shift - up    : yabai -m window --warp north
                   alt + shift - right : yabai -m window --warp east
       # fast focus desktop
       cmd + ctrl - tab : yabai -m space --focus recent
       cmd + ctrl - p : yabai -m space --focus prev
       cmd + ctrl - n : yabai -m space --focus next
       cmd + ctrl - 1 : yabai -m space --focus 1
       cmd + ctrl - 2 : yabai -m space --focus 2
       cmd + ctrl - 0x21 : yabai -m window --focus stack.prev # this is [
                   cmd + ctrl - 0x1E : yabai -m window --focus stack.next # this is ]
    '';
  };
}
