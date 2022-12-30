inputs:
let

  inherit (inputs) nixpkgs home-manager;
  inherit (home-manager.lib) homeManagerConfiguration;

in
{

  "jj@lima" = homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = { inherit inputs; };
    modules = [ ./jj/lima.nix ];
  };

  "jj@urubamba" = homeManagerConfiguration {
    pkgs = nixpkgs.legacyPackages."x86_64-linux";
    extraSpecialArgs = { inherit inputs; };
    modules = [ ./jj/urubamba.nix ];
  };


}
