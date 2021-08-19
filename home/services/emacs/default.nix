{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
    client.enable = true;
  };
}
