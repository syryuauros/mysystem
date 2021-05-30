{ pkgs, ... }:
let

  picom-jonaburg = pkgs.picom.overrideAttrs (old: rec {
    pname = "picom";
    version = "next";

    src = pkgs.fetchFromGitHub {
      owner = "jonaburg";
      repo = "picom";
      rev = "a8445684fe18946604848efb73ace9457b29bf80";
      sha256 = "sha256-R+YUGBrLst6CpUgG9VCwaZ+LiBSDWTp0TLt1Ou4xmpQ";
      fetchSubmodules = true;
    };

  });


in {

  # for jonaburg version
  # services.picom = {
  #   enable = true;
  #   package = picom-jonaburg;
  #   backend = "glx";
  #   experimentalBackends = true;

  #   fade = true;
  #   fadeDelta = 5;

  #   activeOpacity = "0.95";
  #   inactiveOpacity = "0.8";
  #   opacityRule = [
  #     "95:class_g = 'emacs'"
  #     "95:class_i = 'Firefox'"
  #     "95:class_g = 'firefox'"
  #     "95:class_g = 'Navigator'"
  #     "95:class_g = 'Alacritty'"
  #   ];

  #   shadow = true;
  #   shadowOpacity = "0.75";

  #   extraOptions = builtins.readFile ./picom-jonaburg-extra.conf;

  # };

  #for yshui version, shipped in nixpkgs by default
  services.picom = {
    enable = true;
    activeOpacity = "0.95";
    inactiveOpacity = "0.8";
    backend = "glx";
    fade = true;
    fadeDelta = 5;
    # opacityRule = [ "100:name *= 'i3lock'" ];
    shadow = true;
    shadowOpacity = "0.75";
  };

}
