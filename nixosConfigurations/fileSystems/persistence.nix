{ inputs, ... }:
{

  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment = {
    persistence = {
      "/persist".directories = [
        "/var/lib/systemd"
        "/etc/NetworkManager/system-connections"
        "/etc/ssh"
        "/etc/static"
        "/etc"
      ];
    };
    enableAllTerminfo = true;
  };


}
