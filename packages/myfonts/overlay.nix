final: prev:
with final; let

  mkFont = path: runCommand "myfont" {} ''
    target=$out/share/fonts/myfont
    mkdir -p $target
    cp ${path}/*.ttf ${path}/*.otf $target
  '';

in {

  myfonts = callPackage ./deriv.nix {};

  cute-font      = mkFont ./fonts/Cute_Font;
  hi-melody      = mkFont ./fonts/Hi_Melody;
  kirang-haerang = mkFont ./fonts/Kirang_Haerang;
  nanum-gothic   = mkFont ./fonts/Nanum_Gothic;
  nanum-myeongjo = mkFont ./fonts/Nanum_Myeongjo;
  noto-sans-kr   = mkFont ./fonts/Noto_Sans_KR;
  noto-serif-kr  = mkFont ./fonts/Noto_Serif_KR;
  seoul-hangan   = mkFont ./fonts/Seoul_Hangan;
  single-day     = mkFont ./fonts/Single_Day;
  sunflower      = mkFont ./fonts/Sunflower;
  yeon-sung      = mkfont ./fonts/Yeon_Sung;

  mynerdfonts = prev.nerdfonts.override {
    fonts = [
      "Mononoki"
      "SourceCodePro"
      "FiraCode"
      "Noto"
    ];
  };

  myfonts-collection = with final; [
    # myfonts
    noto-sans-kr
    # noto-serif-kr
    # nerdfonts
    symbola
    seoul-hangan
    mynerdfonts
    noto-fonts-cjk
    # noto-fonts
    material-design-icons
    weather-icons
    font-awesome
    emacs-all-the-icons-fonts
  ];

}
