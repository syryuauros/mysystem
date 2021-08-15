{ ... }:
{

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  networking.wireguard.interfaces = {
    wg0 = {
      ips = [ "10.100.0.4/24" ];
      listenPort = 51820;
      privateKeyFile = "/home/jj/wireguard-keys/private";
      peers = [
        {
          publicKey = "iFb4Ua34391/8hwCY3F3a3ceMZggkvZqo4dQZqi3ATo=";
          allowedIPs = [ "10.100.0.1/32"
                         "10.100.0.2/32"
                         "10.100.0.3/32"
                         "10.100.0.4/32"
                       ];
          endpoint = "haedosa.xyz:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
