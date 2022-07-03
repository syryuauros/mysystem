{ inputs, config, lib, pkgs, ... }: {


  imports = [
    ./syncthing.nix
    ./dropbox.nix
  ];

  services.blueman.enable = true;

  services.geoclue2.enable = true;

  services.xserver.layout = "us";
  # services.xserver.xkbVariant = ",dvorak";
  # xkbOptions = "caps:ctrl_modifier,altwin:swap_lalt_lwin"; # set separatedly for each machine


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

  services.clipmenu.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    # pkgs.brlaser pkgs.brgenml1cupswrapper
  ];

  # services.tailscale = {
  #   enable = true;
  # };
}
