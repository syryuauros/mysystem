{ name, port, wg-key, wg-ips, allowedIPs } : { config, lib, pkgs, ... }:

{
  networking.firewall = {
    allowedUDPPorts = [ port ];
  };

  age.secrets.wg.file = wg-key;

  networking.wireguard.interfaces = {
    "${name}" = {
      ips = wg-ips;
      listenPort = port;
      privateKeyFile = config.age.secrets.wg.path;
      peers = [
        {
          publicKey = "i0ZorMa8S9fT8/TI/U01K5HGhYPGRESnrq36k2I7MBU=";
          allowedIPs = allowedIPs;
          endpoint = "121.136.244.64:${toString port}";
          persistentKeepalive = 25;
        }
      ];
    };
  };
}
