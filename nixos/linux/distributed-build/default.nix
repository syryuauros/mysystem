{ config, lib, pkgs, ... }:

{

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "builder1";
      # sshUser = "root";
      # sshKey = "/home/jj/.ssh/id_builder";
      system = "x86_64-linux";
      maxJobs = 6;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "builder2";
      # sshUser = "root";
      # sshKey = "/home/jj/.ssh/id_builder";
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

  # programs.ssh.extraConfig = ''
  #   Host builder1
  #     HostName 10.10.100.1
  #     User root
  #     IdentityFile /home/jj/.ssh/id_builder
  #   Host builder2
  #     HostName 10.10.100.2
  #     User root
  #     IdentityFile /home/jj/.ssh/id_builder
  # '';

  programs.ssh.extraConfig = ''
    Host builder1
      HostName 121.136.244.64
      User root
      Port 101
      IdentityFile /home/jj/.ssh/id_builder
    Host builder2
      HostName 121.136.244.64
      User root
      Port 102
      IdentityFile /home/jj/.ssh/id_builder
  '';

  # services.openssh.knownHosts."10.10.100.1".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9IObSEcyb3+3gGXuG8uUGIUiWAuW6hPjoq0059SvZ";
  # services.openssh.knownHosts."10.10.100.2".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpvlvAsXnWatOi0JLmrzy6ri443CuvujgW4k86i91Sn";
  services.openssh.knownHosts."[121.136.244.64]:101".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy9IObSEcyb3+3gGXuG8uUGIUiWAuW6hPjoq0059SvZ";
  services.openssh.knownHosts."[121.136.244.64]:102".publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGpvlvAsXnWatOi0JLmrzy6ri443CuvujgW4k86i91Sn";

}
