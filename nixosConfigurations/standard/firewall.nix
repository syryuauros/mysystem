{

  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 69 4011 80 8080 8081 52647 ];
  networking.firewall.allowedUDPPorts =
    [
      69
      4011  # for pixiecore
      8080
      52647 # for pixiecore
    ];


}
