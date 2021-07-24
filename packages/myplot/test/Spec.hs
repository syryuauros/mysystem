module Main where

import           Test.Hspec
import           My.Plot.XYSpec                   (testXY)

main :: IO ()
main = hspec $ do

  describe "XY Plot Test"
    testXY
