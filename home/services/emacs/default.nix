{ pkgs, ... }:
{
  services.emacs = {
    enable = true;
    package = pkgs.myEmacs;
    client.enable = true;
  };
}
