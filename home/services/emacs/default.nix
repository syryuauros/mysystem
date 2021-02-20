{ pkgs, ... }:

{
  services.emacs = {
    enable = true;
    package = pkgs.myemacs;
    client.enable = true;
  };
}
