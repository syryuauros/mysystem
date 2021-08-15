{ ... }:
{

  networking.firewall.checkReversePath = false;

  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.0.0.3/24" ];
      dns = [ "10.0.0.1" ];
      privateKeyFile = "/home/jj/wireguard-keys/private";

      peers = [
        {
          publicKey = "iFb4Ua34391/8hwCY3F3a3ceMZggkvZqo4dQZqi3ATo=";
          allowedIPs = [ "10.0.0.1/24"
                         "10.0.0.2/24"
                       ];
          endpoint = "13.124.118.167:51820";
          persistentKeepalive = 25;
        }
      ];
    };
  };

}
