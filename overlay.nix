final: prev: with final;
{

  extra-monitor = callPackage ./packages/scripts/extra-monitor {};
  restart-xmonad = callPackage ./packages/scripts/restart-xmonad {};
  dracula-qutebrowser = callPackage ./packages/dracula-qutebrowser {};

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
