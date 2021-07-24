final: prev: with final; {

  mywallpapers-1366 = runCommand "mywallpapers-1366" {} ''
    mkdir -p $out
    cp ${./images}/* $out
  '';

}
