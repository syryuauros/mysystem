inputs: system:
let

  inherit (inputs.self) nixosConfigurations;

  pkgs = import ../pkgs.nix { inherit inputs system; };
  mylib = import ../lib pkgs;

  inherit (builtins) mapAttrs;
  inherit (mylib) get-toplevel get-isoimage;

  nixosSystems =
    (mapAttrs (_ : get-toplevel) nixosConfigurations) // {
      iguazu = get-isoimage nixosConfigurations.iguazu;
      usb = get-isoimage nixosConfigurations.usb;
    };

  inherit (pkgs) callPackage;

  tmux = callPackage ./tmux {};
  tex = callPackage ./tex {};
  myfonts = callPackage ./myfonts {};
  myscripts = callPackage ./myscripts {};


in nixosSystems
// myfonts
// myscripts
//
{
  inherit tmux tex;
}
