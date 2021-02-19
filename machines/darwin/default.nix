{ inputs, config, pkgs, lib, ... }:
let

  prefix = "/run/current-system/sw/bin";

in {

  imports = [
    ./bootstrap.nix
    ./services/skhd
    ./services/yabai
    # ./services/spacebar
  ] ++ lib.filter lib.pathExists [ ./private.nix ];


  environment = {

    loginShell = pkgs.fish;
    # pathsToLink = [ "/Applications" ];
    # backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };

  };

  time.timeZone = "Asia/Seoul";


  fonts.enableFontDir = true;
  fonts.fonts = pkgs.myfonts-collection;


  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    # remapCapsLockToEscape = true;
  };

  system.defaults = {

    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "bottom";
      mineffect = "scale";
      showhidden = true;
      launchanim = false;
      show-recents = false;
      expose-group-by-app = false;
      minimize-to-application = true;
      show-process-indicators = true;
      tilesize = 80;
      #mouse-over-hilite-stack = false;
    };

    # screencapture.location = "/tmp";

    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
    };

    #trackpad = {
    #  Clicking = true;
    #  TrackpadThreeFingerDrag = true;
    #};

    #NSGlobalDomain.

    NSGlobalDomain = {
      AppleMeasurementUnits = "Centimeters";
      AppleMetricUnits = 1;
      AppleShowScrollBars = "Automatic";
      AppleTemperatureUnit = "Celsius";
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticPeriodSubstitutionEnabled = false;
      _HIHideMenuBar = false;
      "com.apple.trackpad.scaling" = "3.0";
      "com.apple.mouse.tapBehavior" = null;
    };

    # Firewall
    alf = {
      globalstate = 1;
      allowsignedenabled = 1;
      allowdownloadsignedenabled = 1;
      stealthenabled = 1;
    };


    # Login and lock screen
    loginwindow = {
      GuestEnabled = false;
      DisableConsoleAccess = true;
    };

    # Spaces
    spaces.spans-displays = false;

    # Trackpad
    trackpad = {
      Clicking = false;
      TrackpadRightClick = true;
    };


  };

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

}
