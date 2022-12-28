{ config, pkgs, modulesPath, inputs, ... }:
{

  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    ../../users
    ../../basic/configuration.nix
  ];

  networking.hostName = "usb";
  networking.wireless.enable = true;

  environment.systemPackages = with pkgs; [];

  # faster compression, sacrifying volume
  # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
