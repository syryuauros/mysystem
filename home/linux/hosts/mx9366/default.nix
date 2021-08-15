{ config, pkgs , lib , ... }:

{

  imports = [
    ../../desktop
  ];


  home.packages = with pkgs; [
    myhaskell-full
    mypython-full-cuda
    myjupyter-full-cuda
  ];

}
