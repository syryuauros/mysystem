{
  services.xserver = {
    enable = true;

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
      mouse = {
        disableWhileTyping = true;
        naturalScrolling = true;
      };
    };

    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };
}
