{ pkgs, ... }:
let
  # callPackage Helper
  callPackageGit = repo: args:
    pkgs.callPackage (import "${builtins.fetchGit repo}") args;

  # api backend
  hsite = (callPackageGit
            { url = "git@gitlab.com:wavetojj/hsite.git";
              ref = "master";
              rev = "8806f2607db9114d3d47c002f1f0fc8380b81b06";
            } {}).hsite;
in {

  # Enable HTTP server
  # services.httpd = {
  #   enable = true;
  #   adminAddr = "wavetojj@gmail.com";
  #   virtualHosts = {
  #     localhost = {
  #       documentRoot = "/home/web";
  #     };
  #   };
  # };

  services.nginx = {
    enable = true;
    virtualHosts."x230.com" = {
      # forceSSL = true;
      # enableACME = true;
      root = "/home/web";
      locations."/api".proxyPass = "http://127.0.0.1:3000";
    };
  };

  # systemd.services.hsite = {
  #   description = "hsite backend";
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig.ExecStart = "${hsite}/bin/hserver";
  # };

}
