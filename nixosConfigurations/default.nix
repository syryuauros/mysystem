inputs:
let

  inherit (inputs.nixpkgs.lib) nixosSystem;
  specialArgs = { inherit inputs; };

in
{
  urubamba = nixosSystem {
    inherit specialArgs;
    modules = [ ./hosts/urubamba ];
  };

  lima = nixosSystem {
    inherit specialArgs;
    modules = [ ./hosts/lima ];
  };

  # iguazu is for a USB installer
  iguazu = nixosSystem {
    inherit specialArgs;
    modules = [ ./hosts/iguazu ];
  };

  garganta = nixosSystem {
    inherit specialArgs;
    modules = [ ./hosts/garganta ];
  };

  usb = nixosSystem {
    inherit specialArgs;
    modules = [ ./hosts/usb ];
  };
}
