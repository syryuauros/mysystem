{ pem-key } : { config, ... }:

{

  age.secrets.NixServePemKey.file = pem-key;

  services.nix-serve = {
    enable = true;
    # openFirewall = true;
    bindAddress = "127.0.0.1";
    secretKeyFile = config.age.secrets.NixServePemKey.path;
  };

  networking.firewall.allowedTCPPorts = [ 80 ];

  services.nginx = {
    enable = true;
    virtualHosts = {
      "giron" = {
        serverAliases = [ "giron" ];
        locations."/".extraConfig = ''
          proxy_pass http://localhost:${toString config.services.nix-serve.port};
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        '';
      };
    };
  };

}
