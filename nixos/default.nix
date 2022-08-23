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
      binary-caches-parallel-connections = 3
      connect-timeout = 2
    '';


    settings = {

      substituters = [
        "http://haedosa.xyz:201" "http://10.10.100.1" "http://192.168.100.54"
        "http://haedosa.xyz:202" "http://10.10.100.2" "http://192.168.100.55"
        "http://haedosa.xyz:203" "http://10.10.100.3" "http://192.168.100.97"
        "http://haedosa.xyz:204" "http://10.10.100.4" "http://192.168.100.101"
        "http://haedosa.xyz:205" "http://10.10.100.5" "http://192.168.100.102"
        "http://haedosa.xyz:206" "http://10.10.100.6" "http://192.168.100.70"
        "https://cache.nixos.org/"
        "https://hydra.iohk.io"
        "https://cachix.cachix.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        # "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];

      trusted-public-keys = [
        "builder1:W5idzEOcUKokokJV6K/9yEKgAtUcBH3IIZ23yE+XW7k="
        "builder2:R7X06/w5h5SfUO4ZvTkkfIjHHEDhrOFYLoQjYVIrFLM="
        "builder3:ICrJJg0EV8V5n90xghprYM7hEZg+dJ5T06gyaHqZtKU="
        "builder4:g2y9eiBfz+zWX6PGbXSxiRcJcW6+7RFZh0TXwF8cmcc="
        "builder5:+3i3teuBVBQXR47k9M0zLVmdzirKSGm9+9awX2jp+u0="
        "builder6:LoWfwaMHhw0E4FrXq3qlTvslOgZHh7fIPFVcfPy3UXo="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
        # "https://nixpkgs-wayland.cachix.org"
      ];

      trusted-users = [
        "root" "@admin" "@wheel"
      ];

      require-sigs = false;

    };



    gc = {
      automatic = false;
      options = "--delete-older-than 90d";
    };


    # buildCores = 8;
    # maxJobs = 8;
    # readOnlyStore = true;
    # nixPath = [
    #   "nixpkgs=/etc/${config.environment.etc.nixpkgs.target}"
    #   "home-manager=/etc/${config.environment.etc.home-manager.target}"
    # ];

  };


  imports = [
    # ./users
    ./i18n
    ./xserver
    ./services
    ./hardware
    ./distributed-build
    ./nfs
    # ./ipfs
  ];


  # mymodules.sway.enable = true;

  fonts.fontconfig.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  security.sudo.wheelNeedsPassword = false;

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "262144";
    }
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  system.stateVersion = "22.05";

}
