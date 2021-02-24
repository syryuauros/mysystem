{ pkgs, ... }:

{

  imports = [
    ../users
    ../xserver
    ../services/blueman
    ../services/ssh
  ];

  fonts.fontconfig.enable = true;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod.enabled = "uim";
  };

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

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

}
