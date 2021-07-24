{ mkDerivation
, base
}:
mkDerivation rec {
  pname = "myflow";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = false;
  libraryHaskellDepends = [ base ];
  license = "private";
}
