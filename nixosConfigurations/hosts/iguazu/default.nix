{ config, pkgs, modulesPath, inputs, ... }:
let

  inherit (inputs.self) nixosConfigurations;

  utils = import ../../../lib/utils.nix pkgs;
  scripts = import ../../../lib/scripts.nix pkgs;
  snippets = import ../../../lib/snippets.nix pkgs;

  switch-to-garganta =
    let
      garganta = utils.get-toplevel nixosConfigurations.garganta;
    in
    pkgs.writeShellScriptBin "switch-to-garganta" ''
      ${snippets.create-btrfs-subvolumes { }}
      ${snippets.mount-btrfs-subvolumes { }}
      ${pkgs.nixFlakes}/bin/nix copy ${garganta} --to /mnt
      ${snippets.switch-after-enter { system-toplevel = garganta; }}
    '';

in
{

  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix")
    ../../users
    ../../basic/configuration.nix
    ../../basic/nix.nix
  ];

  networking.hostName = "iguazu";

  environment.systemPackages = with pkgs; [
    gparted
    nix-prefetch-scripts

    scripts.partition-format
    scripts.create-btrfs-subvolumes
    scripts.mount-btrfs-subvolumes
    switch-to-garganta
  ];

  # uncomment this if the nvidia driver is required
  # services.xserver.videoDrivers = [ "nvidia" ];

  # faster compression, sacrifying volume
  # https://nixos.wiki/wiki/Creating_a_NixOS_live_CD
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
