{ inputs, config, pkgs, lib, ... }:

{

  imports = [
    ../../common
    # ./bootstrap.nix
  ] ++ [
    ./../services/skhd
    ./../services/yabai
    # ./../services/spacebar
    ./../services/emacs
  ] ++ lib.filter lib.pathExists [ ./private.nix ];


  environment = {

    loginShell = pkgs.fish;
    # pathsToLink = [ "~/Applications" ];
    # backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };

    # variables.SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.fish.babelfishPackage = pkgs.babelfish;
  # Needed to address bug where $PATH is not properly set for fish:
  # https://github.com/LnL7/nix-darwin/issues/122
  programs.fish.shellInit = ''
    for p in (string split : ${config.environment.systemPath})
      if not contains $p $fish_user_paths
        set -g fish_user_paths $fish_user_paths $p
      end
    end
  '';

  time.timeZone = "Asia/Seoul";

  fonts.enableFontDir = true;
  fonts.fonts = pkgs.myfonts-collection;

  users.nix.configureBuildUsers = true;

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
      Clicking = true;
      Dragging = true;
      TrackpadRightClick = true;
      TrackpadThreeFingerDrag = true;
    };


  };

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

  services.nix-daemon.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
