{ config, lib, pkgs, ... }: let

  cfg = config.services.ipfs;

in {

  services.ipfs = {
    enable = true;
    autoMount = true;
    extraConfig = {
      Bootstrap = [
        "/ip4/10.10.0.2/tcp/4001/p2p/12D3KooWMkZZFJ6oSVDEz7CZNcZPYpL289Y5ws3SD3UTSGbpRd29"
        "/ip4/10.10.0.21/tcp/4001/p2p/12D3KooWBSpgEmP1d7cHpGui1QQqyC68eoUZWMuwM7rDbcj776KV"
        "/ip4/10.10.0.22/tcp/4001/p2p/12D3KooWLATaGuMcWMZbwFZzgB8KByjQJ9aaGGGT2CxGkpzu4AiD"
      ];
      Swarm.AddrFilters = null;
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
    file = ../../../secrets/ipfs-swarm-key.age;
    path = cfg.dataDir + "/swarm.key";
    owner = cfg.user;
    group = cfg.group;
    symlink = false;
  };

}
