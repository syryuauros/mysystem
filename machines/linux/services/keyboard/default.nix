{ pkgs, ... }:

{

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = ",dvorak";
  # xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin"; # set separatedly for each machine
}
