final: prev:
with final; {

  myfonts = callPackage ./deriv.nix {};

  mynerdfonts = prev.nerdfonts.override {
    fonts = [
      "Mononoki"
      "SourceCodePro"
      "FiraCode"
      "Noto"
    ];
  };

  myfonts-collection = with final; [
    myfonts
    # nerdfonts
    mynerdfonts
    noto-fonts
    material-design-icons
    weather-icons
    font-awesome
    emacs-all-the-icons-fonts
  ];

}
