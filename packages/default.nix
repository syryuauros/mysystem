inputs: system:
let

  inherit (inputs.self) nixosConfigurations;

  pkgs = import ../pkgs.nix { inherit inputs system; };
  mylib = import ../lib pkgs;

  inherit (builtins) mapAttrs;
  inherit (mylib) get-toplevel get-isoimage;

  nixosSystems =
    (mapAttrs (_ : get-toplevel) nixosConfigurations) // {
      # iguazu = get-isoimage nixosConfigurations.iguazu;
      # usb = get-isoimage nixosConfigurations.usb;
    };

  remote-install = { system-toplevel, mount-point ? "/mnt" }:
    pkgs.writeShellScriptBin "remote-install" ''
      ${pkgs.nix}/bin/nix copy ${system-toplevel}
      ${pkgs.nixos-install}/bin/nixos-install --root ${mount-point} --system ${system-toplevel} --no-root-passwd
    '';

  inherit (pkgs) callPackage;

  tmux = callPackage ./tmux {};
  tex = callPackage ./tex {};
  # myfonts = callPackage ./myfonts {};
  myfonts = import ./myfonts { inherit (pkgs) runCommand nerdfonts; };
  myscripts = import ./myscripts { inherit pkgs; };
  # screenlayout = callPackage ./myscripts/screenlayout {};
  # restart-xmonad = callPackage ./myscripts/restart-xmonad {};
  # mysetxkbmap = callPackage ./myscripts/mysetxkbmap {};
  # dmenu-scripts = callPackage ./myscripts/dmenu-scripts {};
  # myinstall = callPackage ./myscripts/myinstall {};
  # trim-generations = callPackage ./myscripts/trim-generations {};

  doom-private = callPackage ./doom-private {};

in nixosSystems
// myfonts
// myscripts
# //
# {
#   inherit  screenlayout restart-xmonad mysetxkbmap dmenu-scripts trim-generations;
#   #inherit  screenlayout restart-xmonad mysetxkbmap dmenu-scripts myinstall trim-generations;
# }

//
{
  inherit tmux tex doom-private;
}
