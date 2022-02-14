{ config, lib, pkgs, ... }:

{

  services.ipfs = {
    enable = true;
  };

  security.wrappers = {
    ipfs = let
      cfg = config.services.ipfs;
    in {
      setuid = true;
      permissions = "u+rx,g+x";
      owner = cfg.user;
      group = cfg.group;
      source = "${cfg.package}/bin/ipfs";
    };
  };


}
