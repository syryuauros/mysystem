{ pkgs, ... }:

{

  imports = [
    ../users
    ../i18n
    ../xserver
    ../services/blueman
    ../services/ssh
    ../hardware/acpilight
    ../hardware/audio
  ];

  fonts.fontconfig.enable = true;

  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # Set your time zone.
  time.timeZone = "Asia/Seoul";

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 8081 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

}
