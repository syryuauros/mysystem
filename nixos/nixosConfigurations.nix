{ inputs, mkNixosSystem, jj }:
{

  urubamba = mkNixosSystem {
    hostName = "urubamba";
    wg-ip = "10.10.0.2/32";
    modules = [ jj.nixosModule
                jj.homeModule ];
  };

  lima = mkNixosSystem {
    hostName = "lima";
    wg-ip = "10.10.0.21/32";
    modules = [ jj.nixosModule
                jj.homeModule ];
  };

  bogota = mkNixosSystem {
    hostName = "bogota";
    wg-ip = "10.10.0.22/32";
    modules = [
      jj.nixosModule
      jj.homeModule
      { services.xserver.videoDrivers = [ "nvidia" "intel" ]; }
      ({ config, pkgs, ... }: let
          fmmdosa-api = inputs.fmmdosa-api.defaultPackage.${pkgs.system};
        in {
        systemd.services.fmmdosa-api = {
          enable = true;
          description = "fmmdosa-api";
          wantedBy = ["multi-user.target"];
          serviceConfig.ExecStart = "${fmmdosa-api}/bin/fmmdosa-api";
        };
        networking.firewall.allowedTCPPorts = [ 80 443 3000 ];
        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          virtualHosts."fmmdosa-api" = {
            # enableACME = true;
            # addSSL = true;
            locations."/fmmdosa-api".proxyPass =
                "http://localhost:3000";
          };
        };
      })
    ];
  };

  lapaz = mkNixosSystem {
    hostName = "lapaz";
    wg-ip = "10.10.0.23/32";
    modules = [ jj.nixosModule
                jj.homeModule ];
  };

  antofagasta = let
    jj' = jj.override {
            homeModules = [{
              xsession.initExtra = ''
                # xinput set-prop "HAILUCK CO.,LTD USB KEYBOARD Mouse" 325 0
                sl-antofagasta.sh
              '';
            }];
          };
  in mkNixosSystem {
    hostName = "antofagasta";
    wg-ip = "10.10.0.24/32";
    modules = [
      jj.nixosModule
      jj'.homeModule
      (import ./gpd-pocket3.nix)
    ];
    # deploy-ip = "192.168.68.69";
  };

}
