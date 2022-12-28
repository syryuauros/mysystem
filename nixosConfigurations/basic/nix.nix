{ config, lib, pkgs, ... }:

{

  nix = {

    package = pkgs.nixVersions.stable;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixVersions.stable)
      "experimental-features = nix-command flakes"}
    '';

    settings = {

      substituters = [
        "https://cache.nixos.org/"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];

      trusted-users = [
        "jj" "root" "@admin" "@wheel"
      ];

      require-sigs = false;

    };

    gc = {
      automatic = false;
      options = "--delete-older-than 90d";
    };

  };

}
