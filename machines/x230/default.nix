{ config, pkgs, ... }:
{
  imports = [
    ../common
    ../linux/common
    ./configuration.nix
  ];
}
