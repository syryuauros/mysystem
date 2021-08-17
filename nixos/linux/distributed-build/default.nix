{ config, lib, pkgs, ... }:

{

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "legion5i";
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

  programs.ssh.extraConfig = ''
    Host legion5i
      HostName 10.100.0.5
  '';

}
