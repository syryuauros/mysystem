{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     GADTs
                 #-}

module My.Plot.XY.VegaLite
  (
    writeJson
  , writeHtml
  , plotJson
  , plotHtml
  , plotDualPanel
  ) where

import           My.Flow
import           ClassyPrelude
import           Data.Aeson                       ( Value )
import qualified Data.ByteString.Lazy             as LB
import           Graphics.Vega.VegaLite

import           My.Plot.Common
import           My.Plot.XY.Types


writeJson :: XYConfig -> InputData -> Text -> IO ()
writeJson config inputData outJson
  =
  plotDualPanel config inputData
  |> fromVL
  |> myEncodePretty
  |> \vl ->
  do
    putStrLn $ "Writing " <> outJson
    LB.writeFile (unpack outJson) vl


writeHtml :: XYConfig -> InputData -> Text -> IO ()
writeHtml config inputData outHtml
  =
  plotDualPanel config inputData
  |> \vl ->
  do
    putStrLn $ "Writing " <> outHtml
    toHtmlFile (unpack outHtml) vl


data ViewLevel = Overview
               | Detailed
               deriving (Eq)


plotJson :: XYConfig -> InputData -> Value
plotJson config inputData
  = fromVL $ plotDualPanel config inputData


plotHtml :: XYConfig -> InputData -> LText
plotHtml config inputData
  = toHtml $ plotDualPanel config inputData


plotDualPanel :: XYConfig ->  InputData -> VegaLite
plotDualPanel (XYConfig xfield yfield yerrMay colorMay shapeMay dashMay xlog ylog)
       inputData = let

  data_          = case inputData of
                     Embeded val -> dataFromJson val []
                     PathTo  path  -> dataFromUrl path []
  wd             = width 600
  ht             = height 300

  -- default maginified area does not make sense mostly
  -- xlim           = (Number 500, Number 1000)
  -- ylim           = (Number 0.000001, Number 0.001)
  selName        = "brush"
  selRegion      = selection
                     . select selName Interval
                         [ Encodings [ChX, ChY]
                         -- , SInitInterval (Just xlim) (Just ylim)
                         ]
                     $ []

  selHover       = selection
                     . case colorMay of
                         Nothing -> id
                         Just color_ ->
                           select "hover" Single
                             [ On "mouseover"
                             , Fields [ color_ ]
                             ]
                      $ []

  domainOpt fld  = SDomainOpt (DSelectionField selName fld)

  mkColor        = case colorMay of
                     Nothing -> id
                     Just color_ ->
                       color [ MSelectionCondition (SelectionName "hover")
                               [ MName color_ , MmType Nominal]
                               [ MString "grey" ]
                             ]

  mkOpacity      = opacity [ MSelectionCondition (SelectionName "hover")
                             [ MNumber 1]
                             [ MNumber 0.1]
                           ]

  mkShape        = case shapeMay of
                     Nothing -> id
                     Just shape_ ->
                       shape [ MName shape_ , MmType Nominal]

  mkDash        = case dashMay of
                     Nothing -> id
                     Just dash_ ->
                       strokeDash [ MName dash_ , MmType Nominal]

  mkYErrorBar    = case yerrMay of
                    Nothing -> id
                    Just field ->
                      position YError [ PName field ]

  yLogScale     = case ylog of
                    LinearScale -> [ SType ScLinear ]
                    LogScale    -> [ SType ScLog ]
  xLogScale     = case xlog of
                    LinearScale -> [ SType ScLinear ]
                    LogScale    -> [ SType ScLog ]


  mkPositionX viewlevel
    = position X xs
    where
      xs = [ PName xfield
           , PmType Quantitative
           , PTitle xfield
           , PScale $  xLogScale
                    <> [ domainOpt xfield | viewlevel == Detailed ]
           ]

  mkPositionY viewlevel
    = position Y ys
    where
      ys = [ PName yfield
           , PmType Quantitative
           , PTitle yfield
           , PScale $  yLogScale
                    <> [ domainOpt yfield | viewlevel == Detailed ]]

  mkLayer viewlevel
    = layer ([
              asSpec $  [ selRegion | viewlevel == Overview ]
                     <> [ selHover  | viewlevel == Detailed ]
                     <> [ mark Point [ MOpacity 0.80 ] ]
            , asSpec [ mark Line [ MOpacity 0.80 ] ]
            ] <> [
              asSpec [ mark ErrorBar [ MOpacity 0.4, MTicks [ ] ] ] | isJust yerrMay
            ])

  mkPlot viewlevel
    = asSpec [ wd
             , ht
             , encoding
               . mkPositionX viewlevel
               . mkPositionY viewlevel
               . mkYErrorBar
               . mkColor
               . mkOpacity
               . mkShape
               . mkDash
               $ []
             , mkLayer viewlevel
             ]

  in toVegaLite [
                  data_
                , vConcat [ mkPlot Overview
                          , mkPlot Detailed
                          ]
                ]
