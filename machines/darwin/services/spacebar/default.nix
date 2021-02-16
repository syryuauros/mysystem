{ pkgs, ... }:
# {

#   services.spacebar.enable = true;
#   services.spacebar.package = pkgs.spacebar;
#   services.spacebar.config = {
#     debug_output = "on";
#     clock_format = "%R";
#     space_icon_strip = "I II III IV V";
#     text_font = "Mononoki Nerd Font:Regular:12.0";
#     icon_font = "FontAwesome:Regular:12.0";
#     background_color = "0xff202020";
#     foreground_color = "0xffa8a8a8";
#     space_icon_color = "0xff14b1ab";
#     dnd_icon_color = "0xfffcf7bb";
#     clock_icon_color = "0xff99d8d0";
#     power_icon_color = "0xfff69e7b";
#     battery_icon_color = "0xffffbcbc";
#     power_icon_strip = " ";
#     space_icon = "";
#     clock_icon = "";
#     dnd_icon = "";
#   };

# }

{
  services.spacebar.enable = true;
  services.spacebar.package = pkgs.spacebar;
  services.spacebar.config = {
    position           = "top";
    height             = 26;
    spacing_left       = 25;
    spacing_right      = 15;
    text_font          = ''"Mononoki Nerd Font:Regular:12.0"'';
    icon_font          = ''"FontAwesome:Regular:12.0"'';
    background_color   = "0xff202020";
    foreground_color   = "0xffa8a8a8";
    space_icon_color   = "0xff458588";
    power_icon_color   = "0xffcd950c";
    battery_icon_color = "0xffd75f5f";
    dnd_icon_color     = "0xffa8a8a8";
    clock_icon_color   = "0xffa8a8a8";
    space_icon_strip   = "I II III IV V VI VII VIII IX X";
    power_icon_strip   = " ";
    space_icon         = "";
    clock_icon         = "";
    dnd_icon           = "";
    clock_format       = ''"%d/%m/%y %R"'';
  };
}
