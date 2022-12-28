{ inputs, ... }:
{
  environment.etc = {
    home-manager.source = "${inputs.home-manager}";
    nixpkgs.source = "${inputs.nixpkgs}";
  };
}
