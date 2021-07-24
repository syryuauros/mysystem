{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     GADTs
                 #-}


module My.Plot.XYSpec
  ( testXY )
   where

import           ClassyPrelude
import           Test.Hspec                       ( Spec
                                                  , describe
                                                  , it
                                                  , shouldBe
                                                  , beforeAll
                                                  )
import           Data.Aeson                       ( Value
                                                  , decode
                                                  , encode
                                                  )
import           Data.Aeson.Types                 ( emptyObject )
import qualified Data.ByteString.Lazy             as LB
import           Crypto.Hash.SHA256               ( hashlazy )


import           My.Flow                          ( (|>)
                                                  , (|$>)
                                                  )
import           My.Plot.XY.Types
import           My.Plot.XY.VegaLite              ( plotJson )


readInputJson :: IO Value
readInputJson = do
  LB.readFile "test/My/Plot/XYSpec/input.json"
  |$> decode
  |$> fromMaybe emptyObject

readOutputJson :: IO Value
readOutputJson =
  LB.readFile "test/My/Plot/XYSpec/output.json"
  |$> decode
  |$> fromMaybe emptyObject

readInOutputJson :: IO (Value, Value)
readInOutputJson = do
  (,) <$> readInputJson <*> readOutputJson

testXY :: Spec
testXY =

  beforeAll readInOutputJson $ do

    describe "XY Plot Standard Example Test" $ do

      it "Should reproduce the same plot" $ \(inv, outv) ->

        let config = XYConfig { xField     = "epoch"
                              , yField     = "mse"
                              , yError     = Just "mse_std"
                              , colorField = Just "type"
                              , shapeField = Nothing
                              , dashField  = Nothing
                              , xScale     = LinearScale
                              , yScale     = LogScale
                              }
        in (plotJson config (Embeded inv) |> encode |> hashlazy)
        `shouldBe`
        (outv |> encode |> hashlazy)
