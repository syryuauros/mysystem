{ inputs, config, lib, pkgs, ... }: {

  # imports = [ ../modules/primary.nix ];

  user = {
    description = "JJ Kim";
    home = "${
        if pkgs.stdenvNoCC.isDarwin then "/Users" else "/home"
      }/${config.user.name}";
    shell = pkgs.zsh;
  };

  # bootstrap home manager using system config
  # hm = import ./home.nix;

  # let nix manage home-manager profiles and use global nixpkgs
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  #----------------------------------------------------------------------------------------
  #
  #   Bare Minimum Environment
  #
  environment = {
    systemPackages = with pkgs; [

      neovim
      coreutils
      curl
      wget
      git

    ];
    etc = {
      home-manager.source = "${inputs.home-manager}";
      nixpkgs.source = "${inputs.nixpkgs}";
    };
    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bash zsh fish ];
  };



  #----------------------------------------------------------------------------------------
  #
  #  Nix configuration
  #
  nix = {

    package = pkgs.nixFlakes;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
    '';

    binaryCaches = [
      "https://cache.nixos.org/"
    ];

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    # trustedUsers = [ "${config.user.name}" "root" "@admin" "@wheel" ];
    trustedUsers = [
      "root" "@admin" "@wheel"
    ];

    # gc = {
    #   automatic = true;
    #   options = "--delete-older-than 30d";
    # };
    # buildCores = 8;
    # maxJobs = 8;
    # readOnlyStore = true;
    # nixPath = [
    #   "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
    #   "home-manager=/etc/${config.environment.etc.home-manager.target}"
    # ];

  };

  services.nix-daemon.enable = true;

}
