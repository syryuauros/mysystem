{ lib, ... }:
let
  inherit (lib) mkOption types;
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
