{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.XY.ArgParser
  ( Args(..)
  , args
  ) where

import           ClassyPrelude
import           Options.Applicative

import           My.Plot.XY.Types
import           My.Plot.Common.Types

data Args = Args
  { argsInput     :: EitherInput
  , argsFormat    :: InputFormat
  , argsOutput    :: Text
  , argsXaxis     :: Text
  , argsYaxis     :: Text
  , argsYError    :: Maybe Text
  , argsColor     :: Maybe Text
  , argsShape     :: Maybe Text
  , argsDash      :: Maybe Text
  , argsXlog      :: AxisScale
  , argsYlog      :: AxisScale
  , argsEmbed     :: DataEmbed
  } deriving (Show)


args :: IO Args
args = execParser parserWithInfo


parserWithInfo :: ParserInfo Args
parserWithInfo = info (argsParser <**> helper)
  (  fullDesc
  <> header "A simple plot program utilizing vegalite"
  <> progDesc "open the html file to see"
  )


argsParser :: Parser Args
argsParser
  = Args
    <$> (FileInput        -- long      short  meta      help
         <$> fieldParser     "file"     'f'   "FILE"    "Input data file"
         <|> flag1Parser     "stdin"                    "Read data from stdin"
               StdInput)
    <*> ifmtParser           "csv"                      "Set the y-axis the log scale"
    <*> fieldParser          "output"   'o'   "OUTPUT"  "The name of the outputs"
    <*> fieldParser          "xaxis"    'x'   "XAXIS"   "The field name for the x-axis"
    <*> fieldParser          "yaxis"    'y'   "YAXIS"   "The field name for the y-axis"
    <*> optional
          (fieldParser       "yerr"     'e'   "YERROR"  "The field name for the y error bar")
    <*> optional
          (fieldParser       "color"    'c'   "COLOR"   "The field name for the color")
    <*> optional
          (fieldParser       "shape"    's'   "SHAPE"   "The field name for the shape")
    <*> optional
          (fieldParser       "dash"     'd'   "DASH"    "The field name for the stroke dash")
    <*> axisParser           "xlog"                     "Set the x-axis the log scale"
    <*> axisParser           "ylog"                     "Set the y-axis the log scale"
    <*> flag2Parser          "no-embed"                "Do not embed the data but a path"
          EmbedData
          EmbedPath


fieldParser
  :: Text          -- long
  -> Char          -- short
  -> Text          -- meta
  -> Text          -- help message
  -> Parser Text
fieldParser long_ short_ metavar_ help_
  = strOption
    (  long     (unpack long_)
    <> short    short_
    <> metavar  (unpack metavar_)
    <> help     (unpack help_) )

-- ** Log Scale Flags
ifmtParser
  :: Text
  -> Text
  -> Parser InputFormat
ifmtParser long_ help_
  = flag JsonInput CsvInput
    (  long  (unpack long_)
    <> help  (unpack help_))

axisParser
  :: Text
  -> Text
  -> Parser AxisScale
axisParser long_ help_
  = flag2Parser long_ help_ LinearScale LogScale

flag1Parser
  :: Text
  -> Text
  -> a
  -> Parser a
flag1Parser long_ help_ f1
  = flag' f1
    (  long  (unpack long_)
    <> help  (unpack help_))

flag2Parser
  :: Text
  -> Text
  -> a
  -> a
  -> Parser a
flag2Parser long_ help_ f1 f2
  = flag f1 f2
    (  long  (unpack long_)
    <> help  (unpack help_))
