{ inputs, config, pkgs, ... }:
{

  imports = [ inputs.peerix.nixosModules.peerix ];

  age.secrets.peerix.file = ../secrets/peerix.age;

  services.peerix.enable = true;
  services.peerix.openFirewall = true;
  services.peerix.privateKeyFile = config.age.secrets.peerix.path;
  services.peerix.publicKey = "peerix:5In6cUHRQgQUhvnlefNBd/0e7g1TMhmck15UsJv9hxY=";
  services.peerix.user = "peerix";
  services.peerix.group = "peerix";

  users.users.peerix = {
    isSystemUser = true;
    group = "peerix";
  };
  users.groups.peerix = { };

}
