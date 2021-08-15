{ config, lib, pkgs, ... }:

{

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "builder";
      sshUser = "root";
      sshKey = "/root/.ssh/id_builder";
      system = "x86_64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
	    mandatoryFeatures = [ ];
    }
  ];
	nix.extraOptions = ''
		builders-use-substitutes = true
	'';

  programs.ssh.extraConfig = ''
    Host builder
      HostName 100.72.169.29
  '';

}
