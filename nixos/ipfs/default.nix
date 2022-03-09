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
        "/ip4/10.10.0.100/tcp/4001/p2p/12D3KooWFKzK5YTGP33EanwNsn8vuyTaXh56oprKQsPKhj1xZNpC" #js
        "/ip4/10.10.100.1/tcp/4001/p2p/12D3KooWAb5FX2fVPRA9SC72paEYpbjHrmCcggRYZ23e44iaBx4U" # builder1
        "/ip4/10.10.100.2/tcp/4001/p2p/12D3KooWNmp9JToPSrwZuW7JUgcAA7X8BNqqdscx3ePRAsqNDvn2" # builder2
        "/ip4/10.10.100.3/tcp/4001/p2p/12D3KooWDiGWsMM8FRYN5TLDdgZoaaByuaenBDaAYP623WQn8U7T" # builder3
        "/ip4/10.10.100.4/tcp/4001/p2p/12D3KooWHLdp4WFHDZoQ2VxQbFihgNpNY2q18ikEZTs3iqXvn5A3" # builder4
        "/ip4/10.10.100.5/tcp/4001/p2p/12D3KooWKNyyb8Wyii74h92CTNy3RrG64LTnHZoEjNNayiLzvHbN" # builder5
        "/ip4/10.10.100.6/tcp/4001/p2p/12D3KooWRjJZqXsRFmsc6nEifC5U9xwccWDwPDZbjeQbar1EEEXY" # builder6
      ];
      Swarm.AddrFilters = null;
      Swarm.Transports.Network.Relay = true;
      Swarm.EnableAutoRelay = true;
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
      owner = cfg.user;
      group = cfg.group;
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

}
