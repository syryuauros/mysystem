{ inputs, mkNixosSystem, jj }:
{

  urubamba = mkNixosSystem {
    hostName = "urubamba";
    wg-ip = "10.10.0.2/32";
    wg-ip-hds1 = "20.20.0.2/32";
    modules = [ jj.nixosModule
                jj.homeModule
              ];
    # deploy-ip = "192.168.68.81";
  };

  lima = mkNixosSystem {
    hostName = "lima";
    wg-ip = "10.10.0.21/32";
    wg-ip-hds1 = "20.20.0.21/32";
    modules = [ jj.nixosModule
                jj.homeModule ];
  };

  bogota = mkNixosSystem {
    hostName = "bogota";
    wg-ip = "10.10.0.22/32";
    wg-ip-hds1 = "20.20.0.22/32";
    modules = [
      jj.nixosModule
      jj.homeModule
      # inputs.fmmdosa-api.nixosModules.default
      # { services.fmmdosa-api-service.enable = true; }
      # { programs.fmmdosa.enable = true; }
      { services.xserver.videoDrivers = [ "nvidia" "intel" ]; }
    ];
  };

  lapaz = mkNixosSystem {
    hostName = "lapaz";
    wg-ip = "10.10.0.23/32";
    wg-ip-hds1 = "20.20.0.23/32";
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
    wg-ip-hds1 = "20.20.0.24/32";
    modules = [
      jj.nixosModule
      jj'.homeModule
      (import ./gpd-pocket3.nix)
    ];
    # deploy-ip = "192.168.68.69";
  };

}
