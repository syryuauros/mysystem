{ lib, pkgs, config, ... }: let

  key-for-builders = "/home/jj/.ssh/id_ed25519";

in {

  nix = {

    package = pkgs.nixFlakes;

    # Enable experimental version of nix with flakes support
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      ${lib.optionalString (config.nix.package == pkgs.nixFlakes)
      "experimental-features = nix-command flakes"}
      binary-caches-parallel-connections = 3
      connect-timeout = 3
      builders-use-substitutes = true
    '';

    settings = {

      substituters = [
        "http://10.10.100.1" # "http://haedosa.xyz:201" # "http://192.168.100.54"
        "http://10.10.100.2" # "http://haedosa.xyz:202" # "http://192.168.100.55"
        "http://10.10.100.3" # "http://haedosa.xyz:203" # "http://192.168.100.97"
        "http://10.10.100.4" # "http://haedosa.xyz:204" # "http://192.168.100.101"
        "http://10.10.100.5" # "http://haedosa.xyz:205" # "http://192.168.100.102"
        "http://10.10.100.6" # "http://haedosa.xyz:206" # "http://192.168.100.70"
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

    distributedBuilds = true;
    buildMachines = [
      {
        hostName = "builder6";
        system = "x86_64-linux";
        maxJobs = 64;
        speedFactor = 20;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "builder3";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 4;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "builder4";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 4;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "builder5";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 4;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "builder1";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
      {
        hostName = "builder2";
        system = "x86_64-linux";
        maxJobs = 6;
        speedFactor = 2;
        supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
        mandatoryFeatures = [ ];
      }
    ];

  };


  programs.ssh.extraConfig = ''
    Host builder1
      HostName 10.10.100.1
      User root
      IdentityFile ${key-for-builders}
    Host builder2
      HostName 10.10.100.2
      User root
      IdentityFile ${key-for-builders}
    Host builder3
      HostName 10.10.100.3
      User root
      IdentityFile ${key-for-builders}
    Host builder4
      HostName 10.10.100.4
      User root
      IdentityFile ${key-for-builders}
    Host builder5
      HostName 10.10.100.5
      User root
      IdentityFile ${key-for-builders}
    Host builder6
      HostName 10.10.100.6
      User root
      IdentityFile ${key-for-builders}
  '';

  services.openssh.knownHosts."10.10.100.1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9IObSEcyb3+3gGXuG8uUGIUiWAuW6hPjoq0059SvZ";
  services.openssh.knownHosts."10.10.100.2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpvlvAsXnWatOi0JLmrzy6ri443CuvujgW4k86i91Sn";
  services.openssh.knownHosts."10.10.100.3".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJRy4shsolok43LnXTrwWnPyJ+Gna6JYLQKxO66w8ZN";
  services.openssh.knownHosts."10.10.100.4".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsGAj/2BqvU6EUKaeW0ojVNl9yIH+N89z5+LvHsnx8k";
  services.openssh.knownHosts."10.10.100.5".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFkD/jGF/atiNoGlN8WVBUinEfntOr6Vs96B2DWnvUO";
  services.openssh.knownHosts."10.10.100.6".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINsRBagBDoPmuzq1jk8G6PiG6qKXwnG1lWy1dXQGLEgb";


}
