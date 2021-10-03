{ inputs, config, lib, pkgs, ... }: {

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
  };

  environment = {

    systemPackages = with pkgs; [

      neovim
      coreutils
      curl
      wget
      git

    ];

    # etc = {
    #   home-manager.source = "${inputs.home-manager}";
    #   nixpkgs.source = "${inputs.nixpkgs}";
    #   darwin.source = "${inputs.darwin}";
    # };

    # list of acceptable shells in /etc/shells
    shells = with pkgs; [ bashInteractive ];

  };


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
      "http://10.100.100.1"
      "http://10.100.100.2"
      "https://cache.nixos.org/"
    ];

    trustedBinaryCaches = [
      "http://10.100.100.1"
      "http://10.100.100.2"
      "http://10.10.100.1"
      "http://10.10.100.2"
      "https://cache.nixos.org/"
    ];

    binaryCachePublicKeys = [
      "10.100.100.1:W5idzEOcUKokokJV6K/9yEKgAtUcBH3IIZ23yE+XW7k="
      "10.100.100.2:R7X06/w5h5SfUO4ZvTkkfIjHHEDhrOFYLoQjYVIrFLM="
      "10.10.100.1:W5idzEOcUKokokJV6K/9yEKgAtUcBH3IIZ23yE+XW7k="
      "10.10.100.2:R7X06/w5h5SfUO4ZvTkkfIjHHEDhrOFYLoQjYVIrFLM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

    trustedUsers = [
      "root" "@admin" "@wheel"
    ];

    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };

    # buildCores = 8;
    # maxJobs = 8;
    # readOnlyStore = true;
    # nixPath = [
    #   "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
    #   "home-manager=/etc/${config.environment.etc.home-manager.target}"
    # ];

  };

}
