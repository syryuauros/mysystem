{ inputs, config, pkgs, lib, ... }:
let

  prefix = "/run/current-system/sw/bin";

in {

  imports = [
    ./bootstrap.nix
  ] ++ lib.filter lib.pathExists [ ./private.nix ];

  # environment setup
  environment = {

    loginShell = pkgs.fish;
    pathsToLink = [ "/Applications" ];
    # backupFileExtension = "backup";
    etc = { darwin.source = "${inputs.darwin}"; };

  };

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs;
    [
      nerdfonts
      noto-fonts
    ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  # system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;

}
