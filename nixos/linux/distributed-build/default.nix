{ config, lib, pkgs, ... }:

{

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "10.100.100.1";
      sshUser = "root";
      sshKey = "/home/jj/.ssh/id_builder";
      system = "x86_64-linux";
      maxJobs = 6;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "10.100.100.2";
      sshUser = "root";
      sshKey = "/home/jj/.ssh/id_builder";
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

  services.openssh.knownHosts."10.100.100.1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9IObSEcyb3+3gGXuG8uUGIUiWAuW6hPjoq0059SvZ";
  services.openssh.knownHosts."10.100.100.2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpvlvAsXnWatOi0JLmrzy6ri443CuvujgW4k86i91Sn";

}
