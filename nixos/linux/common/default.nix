{ pkgs, ... }:

{

  imports = [
    # ../users
    ../i18n
    ../xserver
    ../services/blueman
    ../services/ssh
    ../services/geoclue2
    ../services/tailscale
    ../hardware/acpilight
    ../hardware/audio
    ../hardware/keyboard
    ../distributed-build
    ../services/syncthing
    ../nfs
    ../ipfs
  ];

  fonts.fontconfig.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  security.sudo.wheelNeedsPassword = false;

  # services.logind.lidSwitch = "ignore";
  services.logind.lidSwitchExternalPower = "ignore";
  services.logind.lidSwitchDocked = "ignore";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

}
