{ config, lib, pkgs, ... }:

{

  imports = [
    ./common.nix
    ./features/cli
  ];

}
