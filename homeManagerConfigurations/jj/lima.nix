{ inputs, ... }:
{
  imports = [
    ./common.nix
  ];

  colorscheme = inputs.nix-colors.colorschemes.silk-dark;
}
