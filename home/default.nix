{ inputs, config, pkgs, ... }: {

  programs = {
    home-manager = {
      enable = true;
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";
    };
  };

  fonts.fontconfig.enable = true;

  imports = [
              # ../../modules/core.nix
              # ../../modules/dotfiles
              # ../home.nix
            ];
}
