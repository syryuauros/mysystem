{
  services.skhd = {
    enable = true;
    skhdConfig = ''

      # launchers
      # lcmd - p : FIXME spotlight
      lalt + lshift - return : alacritty
      lalt + lshift - e      : open ~/.nix-profile/Applications/Emacs.app
      lalt + lshift - w      : open /Applications/Safari.app


      # focus window
      lalt + lshift - h : yabai -m window --focus west
      lalt + lshift - j : yabai -m window --focus south || yabai -m display --focus prev
      lalt + lshift - k : yabai -m window --focus north || yabai -m display --focus next
      lalt + lshift - l : yabai -m window --focus east


      # move window
      lalt + lshift + lctrl - h : yabai -m window --warp west
      lalt + lshift + lctrl - j : yabai -m window --warp south
      lalt + lshift + lctrl - k : yabai -m window --warp north
      lalt + lshift + lctrl - l : yabai -m window --warp east


      # Resize windows
      lctrl + alt - h : \ yabai -m window --resize left:-20:0 ; \
                          yabai -m window --resize right:-20:0

      lctrl + alt - j : \ yabai -m window --resize bottom:0:20 ; \
                          yabai -m window --resize top:0:20

      lctrl + alt - k : \ yabai -m window --resize top:0:-20 ; \
                          yabai -m window --resize bottom:0:-20

      lctrl + alt - l : \ yabai -m window --resize right:20:0 ; \
                          yabai -m window --resize left:20:0


      # Rotate windows clockwise and anticlockwise
      lshift + lalt - r         : yabai -m space --rotate 90
      lalt + lshift + lctrl - r : yabai -m space --rotate 270


      # Move focus container to workspace
      lalt + lshift + lctrl - b : yabai -m window --space last && yabai -m space --focus last
      lalt + lshift + lctrl - n : yabai -m window --space prev && yabai -m space --focus prev
      lalt + lshift + lctrl - m : yabai -m window --space next && yabai -m space --focus next
      lalt + lshift + lctrl - 1 : yabai -m window --space 1 && yabai -m space --focus 1
      lalt + lshift + lctrl - 2 : yabai -m window --space 2 && yabai -m space --focus 2
      lalt + lshift + lctrl - 3 : yabai -m window --space 3 && yabai -m space --focus 3
      lalt + lshift + lctrl - 4 : yabai -m window --space 4 && yabai -m space --focus 4
      lalt + lshift + lctrl - 5 : yabai -m window --space 5 && yabai -m space --focus 5
      lalt + lshift + lctrl - 6 : yabai -m window --space 6 && yabai -m space --focus 6


      # zoom
      lshift + lalt - space          : yabai -m window --toggle zoom-fullscreen
      lalt + lshift + lctrl  - space : yabai -m window --toggle zoom-parent


      lshift + lalt - f     : yabai -m window --toggle float
      lshift + lalt - s     : yabai -m window --toggle split

      # Float and center window
      lalt + lshift + lctrl - f : yabai -m window --toggle float;\
                                  yabai -m window --grid 4:4:1:1:2:2


      # Enable / Disable gaps in current workspace
      lshift + lalt - g : yabai -m space --toggle padding; yabai -m space --toggle gap


      # Rotate on X and Y Axis
      lshift + lalt - x : yabai -m space --mirror x-axis
      lshift + lalt - y : yabai -m space --mirror y-axis


      # Set insertion point for focused container
      rshift + lctrl + lalt - h : yabai -m window --insert west
      rshift + lctrl + lalt - j : yabai -m window --insert south
      rshift + lctrl + lalt - k : yabai -m window --insert north
      rshift + lctrl + lalt - l : yabai -m window --insert east


    '';
  };
}
