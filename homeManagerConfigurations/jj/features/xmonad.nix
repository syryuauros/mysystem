{ inputs, ... }:

{

  imports = [ inputs.myxmonad.homeManagerModules.default ];

  mysystem.windowManager.xmonad.enable = true;

}
