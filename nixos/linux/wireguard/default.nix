ip : { ... }:
{

  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.interfaces = {

    haedosa0 = {
      ips = [ ip ];
      listenPort = 51820;
      privateKeyFile = "/home/jj/.wireguard-keys/private";
      peers = [
        {
          publicKey = "iFb4Ua34391/8hwCY3F3a3ceMZggkvZqo4dQZqi3ATo=";
          allowedIPs = [ "10.100.0.1/32"
                         "10.100.0.2/32"
                         "10.100.0.3/32"
                         "10.100.0.4/32"
                         "10.100.0.5/32"  # legion 5i as a builder
                         "10.100.0.6/32"
                         "10.100.0.7/32"
                       ];
          endpoint = "3.34.133.42:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
