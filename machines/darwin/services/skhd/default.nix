let


  myConfig1 = ''

    # launch programs
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



  myConfig2 = ''


    # launch programs
    shift + alt - return : alacritty
    shift + alt - e      : open ~/.nix-profile/Applications/Emacs.app
    shift + alt - w      : open /Applications/Safari.app

    # focus window
    # here the || was added so the selection cycles and doesn't stop at the end or beginning
    shift + alt - j : yabai -m window --focus prev || yabai -m window --focus last
    shift + alt - k : yabai -m window --focus next || yabai -m window --focus first

    # swap window
    shift + alt - return   : yabai -m window --swap west # swap with "main" tile (simply swap it west)
    shift + alt + ctrl - j : yabai -m window --swap prev || yabai -m window --swap last
    shift + alt + ctrl - k : yabai -m window --swap next || yabai -m window --swap first

    # move window
    shift + cmd - h : yabai -m window --warp west
    shift + cmd - j : yabai -m window --warp north
    shift + cmd - k : yabai -m window --warp south
    shift + cmd - l : yabai -m window --warp east

    # balance size of windows
    shift + alt - 0 : yabai -m space --balance

    # fast focus desktop
    # these don't work for me
    shift + alt - 1 : yabai -m space --focus 1
    shift + alt - 2 : yabai -m space --focus 2
    shift + alt - 3 : yabai -m space --focus 3
    shift + alt - 4 : yabai -m space --focus 4
    shift + alt - 5 : yabai -m space --focus 5
    shift + alt - 6 : yabai -m space --focus 6
    shift + alt - 7 : yabai -m space --focus 7
    shift + alt - 8 : yabai -m space --focus 8
    shift + alt - 9 : yabai -m space --focus 9
    shift + alt - 0 : yabai -m space --focus 10

    # send window to desktop and follow focus
    shift + alt + ctrl - 1 : yabai -m window --space  1
    shift + alt + ctrl - 2 : yabai -m window --space  2
    shift + alt + ctrl - 3 : yabai -m window --space  3
    shift + alt + ctrl - 4 : yabai -m window --space  4
    shift + alt + ctrl - 5 : yabai -m window --space  5
    shift + alt + ctrl - 6 : yabai -m window --space  6
    shift + alt + ctrl - 7 : yabai -m window --space  7
    shift + alt + ctrl - 8 : yabai -m window --space  8
    shift + alt + ctrl - 9 : yabai -m window --space  9
    shift + alt + ctrl - 0 : yabai -m window --space 10

    # increase window size (this is the hack that gives xmonad like resizing)
    shift + alt - h : expr $(yabai -m query --windows --window | jq .frame.x) \< 20 \
                      &&     yabai -m window --resize right:-60:0 \
                      ||     yabai -m window --resize left:-60:0
    shift + alt - l : expr $(yabai -m query --windows --window | jq .frame.x) \< 20 \
                      &&     yabai -m window --resize right:60:0 \
                      ||     yabai -m window --resize left:60:0
    shift + alt - i : yabai -m window --resize bottom:0:-60
    shift + alt - o : yabai -m window --resize bottom:0:60

    # rotate tree
    shift + alt - r : yabai -m space --rotate 90

    # mirror tree y-axis
    shift + alt - y : yabai -m space --mirror y-axis

    # mirror tree x-axis
    shift + alt - x : yabai -m space --mirror x-axis

    # toggle window fullscreen zoom
    shift + alt - space : yabai -m window --toggle zoom-fullscreen

    # toggle window native fullscreen
    # alt - space : yabai -m window --toggle native-fullscreen
    # shift + alt - f : yabai -m window --toggle native-fullscreen

    # toggle window border
    # shift + alt - b : yabai -m window --toggle border

    # toggle window split type
    shift + alt - s : yabai -m window --toggle split

    # float / unfloat window and center on screen
    shift + alt - f : yabai -m window --toggle float;\
                      yabai -m window --grid 12:12:1:1:10:10

    # toggle sticky
    shift + alt + ctrl - s : yabai -m window --toggle sticky

    # toggle sticky, float and resize to picture-in-picture size
    shift + alt - p : yabai -m window --toggle sticky;\
                      yabai -m window --grid 5:5:4:0:2:2

    # change layout of desktop
    shift + alt - a : yabai -m space --layout bsp
    shift + alt - d : yabai -m space --layout float

  '';

in
{
  services.skhd = {
    enable = true;
    skhdConfig = myConfig2;
  };
}
