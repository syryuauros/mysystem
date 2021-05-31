final: prev: with final;
{

  extra-monitor = callPackage ./packages/scripts/extra-monitor {};
  restart-xmonad = callPackage ./packages/scripts/restart-xmonad {};
  dracula-qutebrowser = callPackage ./packages/dracula-qutebrowser {};

  linuxPackages = prev.linuxPackages.extend (self: super: {
    rtw89 = self.callPackage ./packages/rtw89 {};
  });
  linuxPackages_latest = prev.linuxPackages_latest.extend (self: super: {
    rtw89 = self.callPackage ./packages/rtw89 {};
  });
  rtw89-firmware = callPackage ./packages/rtw89-firmware {};

  mytex = texlive.combine {
    inherit (texlive)
      collection-basic
      collection-bibtexextra
      collection-latex
      collection-latexextra
      collection-latexrecommended
      collection-binextra
      collection-langenglish
      collection-langkorean
      collection-langcjk
      collection-plaingeneric
      collection-fontutils
      collection-fontsextra
      collection-fontsrecommended
      collection-context
      collection-metapost
      collection-texworks
      collection-luatex
      collection-xetex
      collection-pictures
      collection-pstricks
      collection-publishers
      collection-mathscience
    ;

  };

}
