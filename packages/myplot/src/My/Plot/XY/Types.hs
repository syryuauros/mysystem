{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     GADTs
                 #-}

module My.Plot.XY.Types where

import           ClassyPrelude
import           Data.Aeson                       ( Value )

data XYErr
  = XYErrNoPathForStdin
  | XYErrNotImplementYet
  | XYErrJsonDecodeFail Text
  | XYErrOutputExists Text

data InputFormat
  = JsonInput
  | CsvInput
  deriving (Show, Eq)

data AxisScale
  = LinearScale
  | LogScale
  deriving (Show, Eq)

data ErrorBar
  = NoErrorBar
  | WithErrorBar
  deriving (Show, Eq)

data DataEmbed
  = EmbedData
  | EmbedPath
  deriving (Show, Eq)

data InputData
  = Embeded Value
  | PathTo  Text
  deriving (Show, Eq)


data XYConfig
  = XYConfig
  { xField       :: Text          -- Field name for x-axis
  , yField       :: Text          -- Field name for y-axis
  , yError       :: Maybe Text    -- Field name for y-axis error or nothing
  , colorField   :: Maybe Text    -- Field name for color or nothing
  , shapeField   :: Maybe Text    -- Field name for shape or nothing
  , dashField    :: Maybe Text    -- Field name for dash or nothing
  , xScale       :: AxisScale     -- Linear or log scale for x-axis
  , yScale       :: AxisScale     -- Linear or log scale for x-axis
  }

defXYConfig :: XYConfig
defXYConfig = XYConfig
            { xField     = "x"
            , yField     = "y"
            , yError     = Nothing
            , colorField = Nothing
            , shapeField = Nothing
            , dashField  = Nothing
            , xScale     = LinearScale
            , yScale     = LinearScale
            }
