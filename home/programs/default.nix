{ config, pkgs , lib , ... }:

{

  imports = [
    ./alacritty
    ./kitty
    ./fish
    ./bash
    ./zsh
    ./starship
    ./fzf
    ./broot
    ./direnv
    ./htop
    ./gpg
    ./ssh
    ./git
    ./zathura
    ./mpv
    ./rofi
    ./firefox
    ./qutebrowser
    ./zathura
    ./xscreensaver
  ];

  programs.home-manager.enable = true;
  programs.bash.enable = true;
  programs.jq.enable = true;
  programs.bat.enable = true;
  programs.zoxide.enable = true;
  programs.pandoc.enable = true;

}
