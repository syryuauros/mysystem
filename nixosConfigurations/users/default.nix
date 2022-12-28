{ config, lib, pkgs, ... }:

{

  users.mutableUsers = false;
  users.extraGroups.data = {};

  imports = [
    ./jj.nix
  ];
}
