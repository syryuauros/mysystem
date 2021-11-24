{ config, lib, pkgs, ... }:

{

  nix.distributedBuilds = true;
  nix.buildMachines = [
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
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  programs.ssh.extraConfig = ''
    Host builder1
      HostName 10.10.100.1
      User root
      IdentityFile /home/jj/.ssh/id_builder
    Host builder2
      HostName 10.10.100.2
      User root
      IdentityFile /home/jj/.ssh/id_builder
    Host builder3
      HostName 10.10.100.3
      User root
      IdentityFile /home/jj/.ssh/id_builder
    Host builder4
      HostName 10.10.100.4
      User root
      IdentityFile /home/jj/.ssh/id_builder
    Host builder5
      HostName 10.10.100.5
      User root
      IdentityFile /home/jj/.ssh/id_builder
  '';

  services.openssh.knownHosts."10.10.100.1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9IObSEcyb3+3gGXuG8uUGIUiWAuW6hPjoq0059SvZ";
  services.openssh.knownHosts."10.10.100.2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpvlvAsXnWatOi0JLmrzy6ri443CuvujgW4k86i91Sn";
  services.openssh.knownHosts."10.10.100.3".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAJRy4shsolok43LnXTrwWnPyJ+Gna6JYLQKxO66w8ZN";
  services.openssh.knownHosts."10.10.100.4".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPsGAj/2BqvU6EUKaeW0ojVNl9yIH+N89z5+LvHsnx8k";
  services.openssh.knownHosts."10.10.100.5".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIFkD/jGF/atiNoGlN8WVBUinEfntOr6Vs96B2DWnvUO";

}
