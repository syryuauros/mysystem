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
                         "10.100.0.6/32"
                         "10.100.0.7/32"
                         "10.100.0.8/32"
                         "10.100.0.9/32"
                         "10.100.0.10/32"
                         "10.100.0.11/32"
                         "10.100.0.100/32"

                         # builders
                         "10.100.0.5/32" "10.100.100.1/32"  # builder1 (legion 5i)
                         "10.100.100.2/32"  # builder2 (legion 5i)

                       ];
          endpoint = "3.34.133.42:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
