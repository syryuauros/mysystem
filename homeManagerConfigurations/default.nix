inputs:
let

  inherit (inputs) nixpkgs home-manager;
  inherit (home-manager.lib) homeManagerConfiguration;

  userInfo = {
    userAccount = "jj";
    userName = "JJ Kim";
    userEmail = "jj@haedosa.xyz";
  };

in
{

  "jj@urubamba" = homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = { inherit inputs userInfo; };
    modules = [ ./jj/urubamba.nix ];
  };

  "jj@lima" = homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = { inherit inputs userInfo; };
    modules = [ ./jj/lima.nix ];
  };

}
