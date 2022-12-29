{

  xdg.enable = true;

  xdg.configFile."mimeapps.list".text = ''
    [Default Applications]
    x-scheme-handler/http=brave-browser.desktop
    x-scheme-handler/https=brave-browser.desktop
    x-scheme-handler/ftp=brave-browser.desktop
    x-scheme-handler/chrome=brave-browser.desktop
    text/html=brave-browser.desktop
    application/x-extension-htm=brave-browser.desktop
    application/x-extension-html=brave-browser.desktop
    application/x-extension-shtml=.desktop
    application/xhtml+xml=brave-browser.desktop
    application/x-extension-xhtml=brave-browser.desktop
    application/x-extension-xht=brave-browser.desktop
    application/pdf=org.pwmt.zathura.desktop
    application/pdf=org.pwmt.zathura.desktop
    inode/directory=xfce4-file-manager.desktop
    image/png=sxiv.desktop
    image/jpeg=sxiv.desktop
    text/plain=nvim.desktop
  '';

}
