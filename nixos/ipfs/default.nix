{ config, lib, pkgs, ... }: let

  cfg = config.services.ipfs;

in {

  services.ipfs = {
    enable = true;
    autoMount = true;
    extraConfig = {
      Bootstrap = [
        "/ip4/10.10.0.1/tcp/4001/p2p/12D3KooWMgtMTRF9R1Hah2r66X1ug2aLGoAg8XyURs9hufgDHrxB" # gateway
        "/ip4/10.10.0.2/tcp/4001/p2p/12D3KooWC5DURAfojXCjKjoKmDREbVncgRrbyJGB69UNpXm6QoNi" # urubamba
        "/ip4/10.10.0.21/tcp/4001/p2p/12D3KooWN3yz1id1qZj7PraSFopk4JFWsWmstvg8eCZtAUpoazjR" # lima
        "/ip4/10.10.0.22/tcp/4001/p2p/12D3KooWLATaGuMcWMZbwFZzgB8KByjQJ9aaGGGT2CxGkpzu4AiD" # bogota
        "/ip4/10.10.0.23/tcp/4001/p2p/12D3KooWSSiJAaNqaiD5zhGcdMdMsHQNf5PqgNwBD3jCQKM1ca2e" # lapaz
        "/ip4/10.10.0.6/tcp/4001/p2p/12D3KooWEJ5S6pqYkcBJ1ovSpjTzLr7mKZtdaoKqAH1FRYN2d1Dg" # kw
        "/ip4/10.10.0.8/tcp/4001/p2p/12D3KooWJZ9MwxKe3Yo9aQh2LHnyosjNhqGvC6ryGNJu89idCKMt" # sth
        "/ip4/10.10.0.100/tcp/4001/p2p/12D3KooWFKzK5YTGP33EanwNsn8vuyTaXh56oprKQsPKhj1xZNpC" # js
        "/ip4/10.10.1.2/tcp/4001/p2p/12D3KooWPDSeka5CTujRWLMysE8ZXWbgoVwLic6EgPmdagNxH8zd" # hoonju
        "/ip4/10.10.100.1/tcp/4001/p2p/12D3KooWAb5FX2fVPRA9SC72paEYpbjHrmCcggRYZ23e44iaBx4U" # builder1
        "/ip4/10.10.100.2/tcp/4001/p2p/12D3KooWNmp9JToPSrwZuW7JUgcAA7X8BNqqdscx3ePRAsqNDvn2" # builder2
        "/ip4/10.10.100.3/tcp/4001/p2p/12D3KooWSb2srJGvzywVCpMK9Uc6moUbi1mPPz1NsGUcTQVfeeP6" # builder3
        "/ip4/10.10.100.4/tcp/4001/p2p/12D3KooWRWYb2tfDUdgbvx3U9euoYkBe4zYsP4nGYsQRvqwoZCYQ" # builder4
        "/ip4/10.10.100.5/tcp/4001/p2p/12D3KooWDHszSCTmkndX9XnQKT3J73xGtLnGzFXkDhHyxucQWH5Y" # builder5
        "/ip4/10.10.100.6/tcp/4001/p2p/12D3KooWRjJZqXsRFmsc6nEifC5U9xwccWDwPDZbjeQbar1EEEXY" # builder6
      ];
      Swarm.AddrFilters = null;
      Swarm.Transports.Network.Relay = true;
      Swarm.EnableAutoRelay = true;
      # Swarm.AutoRelay.Enabled = true;
      # Swarm.RelayService.Enabled = true;
      Discovery.MDNS.Enabled = true;
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
    group = cfg.group;
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
