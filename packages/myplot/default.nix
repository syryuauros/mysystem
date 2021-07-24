{ mkDerivation
, base
, rio
, classy-prelude
, myflow
, optparse-applicative
, hvega
, aeson
, aeson-pretty
, lens-aeson
, turtle
, text
, bytestring
, hspec
, QuickCheck
, cryptohash-sha256
, mtl
, lens
, stringable
, megaparsec
}:
mkDerivation rec {
  pname = "myplot";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [ base
                            rio
                            classy-prelude
                            myflow
                            optparse-applicative
                            hvega
                            aeson
                            aeson-pretty
                            lens-aeson
                            turtle
                            text
                            bytestring
                            hspec
                            QuickCheck
                            cryptohash-sha256
                            mtl
                            lens
                            stringable
                            megaparsec
                          ];
  license = "private";
}
