{ inputs, config, lib, pkgs, ... }: {


  imports = [
    ./syncthing.nix
    ./dropbox.nix
  ];

  services.blueman.enable = true;
  services.geoclue2.enable = true;
  services.upower.enable = true;

  services.dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
      mouse = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  services.gnome.gnome-keyring.enable = true;

  systemd.services.upower.enable = true;
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
    Host 192.168.0.*
      StrictHostKeyChecking no
      UserKnownHostsFile=/dev/null
  '';

  services.clipmenu.enable = true;

  services.printing.enable = true;
  services.printing.drivers = [
    # pkgs.brlaser pkgs.brgenml1cupswrapper
  ];

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  services.avahi.enable = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.domain = true;
  services.avahi.publish.userServices = true;
  services.avahi.publish.workstation = true;
  services.avahi.nssmdns = true;

}
