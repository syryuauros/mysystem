{ config, wg-key, wg-ip, ... }:
{

  networking.firewall = {
    allowedUDPPorts = [ 51821 ];
  };

  age.secrets.wg.file = wg-key;

  networking.wireguard.interfaces = {

    hds0 = {
      ips = [ wg-ip ];
      listenPort = 51821;
      privateKeyFile = config.age.secrets.wg.path;
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
