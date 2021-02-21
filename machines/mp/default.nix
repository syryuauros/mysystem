{ config, pkgs, ... }:
{
  imports = [
    ../common
    ../linux/common
    ../linux/users
    ../linux/xserver
    ./configuration.nix
  ];
}
