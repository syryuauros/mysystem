{ inputs, config, pkgs, ... }:
let
  package = inputs.peerix.defaultPackage.${pkgs.system};
in
{

  imports = [ inputs.peerix.nixosModules.peerix ];

  age.secrets.peerix.file = ../../secrets/peerix.age;

  services.peerix = {
    enable = true;
    inherit package;
    openFirewall = true;
    privateKeyFile = config.age.secrets.peerix.path;
    publicKey = "peerix:5In6cUHRQgQUhvnlefNBd/0e7g1TMhmck15UsJv9hxY=";
    user = "peerix";
    group = "peerix";

  };

  users.users.peerix = {
    isSystemUser = true;
    group = "peerix";
  };
  users.groups.peerix = { };

}
