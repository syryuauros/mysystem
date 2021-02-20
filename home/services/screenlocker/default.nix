{ pkgs, ... }:

{

  services.screen-locker = {
    enable = true;
    inactiveInterval = 10; # min
    lockCmd = "yes | ${pkgs.mylockscreen}/bin/mylockscreen";
    # xautolockExtraOptions = [
    #   "Xautolock.killer: systemctl suspend"
    # ];
  };

}
