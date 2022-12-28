{ config, lib, pkgs, ... }:

{
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;
}
