{ config, lib, pkgs, ... }:
let

  inherit (lib) mkOption types;
  cfg = config.userInfo;

in {
  options.userInfo = mkOption {
    type = types.submodule {
      options = {

        name = mkOption {
          type = types.str;
          example = "JJ Kim";
        };

        email = mkOption {
          type = types.str;
          example = "jj@haedosa.xyz";
        };

      };
    };
  };
}
