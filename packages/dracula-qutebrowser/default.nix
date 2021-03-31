{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation {
  pname = "dracula-qutebrowser";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "dracula";
    repo = "qutebrowser";
    rev = "master";
    sha256 = "sha256-av6laQezAOrBt6P+F2eHWFqAnTEENfDrvzEfhn2dDNY=";
  };

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a * $out
    runHook postInstall
  '';

  meta = with lib; {
    description = "Dracula theme for qutebrowser";
    homepage = "https://github.com/dracula/qutebrowser";
  };
}
