{ config, lib, pkgs, ... }:

{

  boot.kernelParams = [
    "video=DSI-1:panel_orientation=right_side_up"
    "fbcon=rotate:1"
    "mem_sleep_default=s2idle"
  ];
  services.xserver.config = let

    monitor = ''
      Section "Monitor"
        Identifier "DSI-1"
        Option "Rotate" "right"
      EndSection
    '';

    touchScreen = ''
      Section "InputClass"
        Identifier    "calibration"
        Driver        "wacom"
        MatchProduct  "GXTP7380"
        Option        "TransformationMatrix" "0 1 0 -1 0 1 0 0 1"
        Option        "Button2" "3"
      EndSection
    '';

    tearFree = ''
      Section "Device"
        Identifier "modesetting"
        Driver "modesetting"
        Option "TearFree" "True"
      EndSection
    '';

  in lib.mkAfter ''
    ${tearFree}
    ${monitor}
    ${touchScreen}
  '';

}
