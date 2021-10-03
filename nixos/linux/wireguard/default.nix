haedosa0ips: hds0ips: { ... }:
{

  networking.firewall = {
    allowedUDPPorts = [ 51820 51821 ];
  };

  networking.wireguard.interfaces = {

    haedosa0 = {
      ips = haedosa0ips;
      listenPort = 51820;
      privateKeyFile = "/home/jj/.wireguard-keys/private";
      peers = [
        {
          publicKey = "iFb4Ua34391/8hwCY3F3a3ceMZggkvZqo4dQZqi3ATo=";
          allowedIPs = [ "10.100.0.0/16" ];
          endpoint = "3.34.133.42:51820";
          persistentKeepalive = 25;
        }
      ];
    };

    hds0 = {
      ips = hds0ips;
      listenPort = 51821;
      privateKeyFile = "/home/jj/.wireguard-keys/private";
      peers = [
        {
          publicKey = "i0ZorMa8S9fT8/TI/U01K5HGhYPGRESnrq36k2I7MBU=";
          allowedIPs = [ "10.10.0.0/16" ];
          endpoint = "121.136.244.64:51821";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
