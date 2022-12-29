{ config, lib, pkgs, ... }: let

  cfg = config.services.ipfs;

in {

  services.ipfs = {
    enable = true;
    autoMount = true;
    gatewayAddress = "/ip4/0.0.0.0/tcp/8080";
    apiAddress = "/ip4/0.0.0.0/tcp/5001";
    extraConfig = {
      Bootstrap = [
        "/ip4/10.10.0.1/tcp/4001/p2p/12D3KooWMgtMTRF9R1Hah2r66X1ug2aLGoAg8XyURs9hufgDHrxB" # gateway
        "/ip4/10.10.100.1/tcp/4001/p2p/12D3KooWAb5FX2fVPRA9SC72paEYpbjHrmCcggRYZ23e44iaBx4U" # builder1
        "/ip4/10.10.100.2/tcp/4001/p2p/12D3KooWNmp9JToPSrwZuW7JUgcAA7X8BNqqdscx3ePRAsqNDvn2" # builder2
        "/ip4/10.10.100.3/tcp/4001/p2p/12D3KooWSb2srJGvzywVCpMK9Uc6moUbi1mPPz1NsGUcTQVfeeP6" # builder3
        "/ip4/10.10.100.4/tcp/4001/p2p/12D3KooWRWYb2tfDUdgbvx3U9euoYkBe4zYsP4nGYsQRvqwoZCYQ" # builder4
        "/ip4/10.10.100.5/tcp/4001/p2p/12D3KooWDHszSCTmkndX9XnQKT3J73xGtLnGzFXkDhHyxucQWH5Y" # builder5
        "/ip4/10.10.100.6/tcp/4001/p2p/12D3KooWRjJZqXsRFmsc6nEifC5U9xwccWDwPDZbjeQbar1EEEXY" # builder6
      ];
      Swarm.AddrFilters = null;
      # Swarm.Transports.Network.Relay = true;
      # Swarm.EnableAutoRelay = true;
      # # Swarm.AutoRelay.Enabled = true;
      # Swarm.RelayService.Enabled = true;
      # Discovery.MDNS.Enabled = true;
    };
  };

  systemd.services.ipfs.environment = {
    LIBP2P_FORCE_PNET = "1";
  };

  security.wrappers = {
    ipfs = {
      setuid = true;
      permissions = "u+rx,g+x";
      owner = "root";
      group = "ipfs";
      source = "${cfg.package}/bin/ipfs";
    };
  };

  age.secrets.swarm-key = {
    file = ../../secrets/ipfs-swarm-key.age;
    path = cfg.dataDir + "/swarm.key";
    owner = cfg.user;
    inherit (cfg) group;
    symlink = false;
  };

  # age.secrets.ipfs.file = ipfsPrivKey;

  systemd.services.ipfs.preStart = with lib;
    mkForce (
      let
        cfg = config.services.ipfs;
        profile =
          if cfg.localDiscovery
          then "local-discovery"
          else "server";
      in ''
        if [[ ! -f "$IPFS_PATH/config" ]]; then
          ${cfg.package}/bin/ipfs init ${optionalString cfg.emptyRepo "-e"} --profile=${profile}
        else
          # After an unclean shutdown this file may exist which will cause the config command to attempt to talk to the daemon. This will hang forever if systemd is holding our sockets open.
          rm -vf "$IPFS_PATH/api"

          ${cfg.package}/bin/ipfs --offline config profile apply ${profile}
        fi
      '' + optionalString cfg.autoMount ''
        ${cfg.package}/bin/ipfs --offline config Mounts.FuseAllowOther --json true
        ${cfg.package}/bin/ipfs --offline config Mounts.IPFS ${cfg.ipfsMountDir}
        ${cfg.package}/bin/ipfs --offline config Mounts.IPNS ${cfg.ipnsMountDir}
      '' + optionalString cfg.autoMigrate ''
        ${pkgs.ipfs-migrator}/bin/fs-repo-migrations -y
      '' + concatStringsSep "\n" (collect
          isString
          (mapAttrsRecursive
            (path: value:
              # Using heredoc below so that the value is never improperly quoted
              ''
                read value <<EOF
                ${builtins.toJSON value}
                EOF
                ${cfg.package}/bin/ipfs --offline config --json "${concatStringsSep "." path}" "$value"
              '')
            ({
              Addresses.API = cfg.apiAddress;
              Addresses.Gateway = cfg.gatewayAddress;
              Addresses.Swarm = cfg.swarmAddress;
            } //
            cfg.extraConfig)))
      );

}
