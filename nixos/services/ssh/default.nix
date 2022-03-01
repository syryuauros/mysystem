{ pkgs, ... }:

{

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.forwardX11 = true;

  services.openssh.permitRootLogin = "yes";

  programs.ssh.extraConfig = ''
    Host doorkeeper
      HostName 121.136.244.64
      User jj
      ForwardX11 yes
      IdentityFile /home/jj/.ssh/id_rsa
  '';

}
