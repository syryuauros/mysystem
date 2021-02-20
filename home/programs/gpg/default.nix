{ config, pkgs, lib, ... }:

{

  programs.gpg.enable = true;

  home.file.gpg-agent = {
    target = "$HOME/.gnupg/gpg-agent.conf";
    text = ''
      default-cache-ttl 86400
      max-cache-ttl 86400
    '';
  };


}
