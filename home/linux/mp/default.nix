{ config, pkgs , lib , ... }:

{

  imports = [
    ../desktop
  ];

  home.packages = with pkgs; [
    myhaskell-full
    mypython-full
    myjupyter-full
  ];

}
