{ inputs, config, pkgs, lib, ... }:
let

  prefix = "/run/current-system/sw/bin";

in {

  imports = [
    ./bootstrap.nix
    ./services/skhd
    ./services/yabai
    ./services/spacebar
  ] ++ lib.filter lib.pathExists [ ./private.nix ];


  environment = {

    loginShell = pkgs.fish;
    # pathsToLink = [ "/Applications" ];
    # backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };

  };

  time.timeZone = "Asia/Seoul";


  fonts.enableFontDir = true;
  fonts.fonts = with pkgs;
    [
      nerdfonts
      noto-fonts
      material-design-icons
      weather-icons
      font-awesome
      emacs-all-the-icons-fonts
    ];


  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = true;
    # remapCapsLockToEscape = true;
  };

  system.defaults = {
    dock = {
      autohide = true;
      mru-spaces = false;
      orientation = "left";
      mineffect = "scale";
      showhidden = true;
      launchanim = false;
      show-recents = false;
      minimize-to-application = true;
      show-process-indicators = true;
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

    NSGlobalDomain._HIHideMenuBar = true;
    #NSGlobalDomain."com.apple.mouse.tapBehavior" = null;
  };

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

}
