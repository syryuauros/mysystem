{ config, lib, pkgs, ... }: let

  cfg = config.services.ipfs;

in {

  services.ipfs = {
    enable = true;
    user = "ipfs";
    group = "ipfs";
    autoMount = true;
    extraConfig = {
      Bootstrap = [
        "/ip4/10.10.0.2/tcp/4001/p2p/12D3KooWCf2DohGh15Uw7gNafRs9NS1auQLstuLsaQD5ZoXRoxme"
        "/ip4/10.10.0.21/tcp/4001/p2p/12D3KooWCw74c382m6vq8YHqfHN1BeEjGgdhotgDVrgRrAfuuyzb"
        "/ip4/10.10.0.22/tcp/4001/p2p/12D3KooWMTZ2acbt3LauakRNoamg7j1awY2rYYihJEjtmpUqkHe7"
      ];
      Swarm.AddrFilters = null;
    };
  };

  security.wrappers = {
    ipfs = let
      pipfs = pkgs.runCommand "pipfs" { buildInputs = [ pkgs.makeWrapper ]; } ''
        makeWrapper ${cfg.package}/bin/ipfs $out/bin/ipfs --set LIBP2P_FORCE_PNET 1
      '';
    in {
      setuid = true;
      permissions = "u+rx,g+x";
      owner = cfg.user;
      group = cfg.group;
      source = "${pipfs}/bin/ipfs";
    };
  };

  age.secrets.swarm-key = {
    file = ../../../secrets/ipfs-swarm-key.age;
    path = cfg.dataDir + "/swarm.key";
    owner = cfg.user;
    group = cfg.group;
    symlink = false;
  };


}
