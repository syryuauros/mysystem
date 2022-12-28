{ config, lib, pkgs, inputs, modulesPath, ... }:

{

  system.stateVersion = "22.11";
  networking.hostName = "urubamba";

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    inputs.nixos-hardware.nixosModules.common-cpu-intel
    inputs.nixos-hardware.nixosModules.common-pc-laptop-ssd
    inputs.agenix.nixosModules.age

    ../../users
    ../../standard/configuration.nix

    ../../fileSystems/ext4.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

}
