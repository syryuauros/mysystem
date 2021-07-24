{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Common.ArgParser
  ( parseString
  , parseFlag
  , parseStdIn
  , parseEitherInput
  , parseEitherOutput
  , parseOutputFile
  ) where

import           RIO
import           RIO.Text                         ( unpack )
import           Options.Applicative

import           My.Plot.Common.Types

parseString
  :: Text          -- long
  -> Char          -- short
  -> Text          -- meta
  -> Text          -- help message
  -> Parser Text
parseString long_ short_ metavar_ help_
  = strOption
    (  long     (unpack long_)
    <> short    short_
    <> metavar  (unpack metavar_)
    <> help     (unpack help_) )


parseFlag
  :: a
  -> Text
  -> Char
  -> Text
  -> Parser a
parseFlag f1 long_ short_ help_
  = flag' f1
    (  long  (unpack long_)
    <> short short_
    <> help  (unpack help_))


parseEitherInput :: Parser EitherInput
parseEitherInput
  =   FileInput
  <$> parseString "file" 'f' "FILE" "Input File"
  <|> parseStdIn


parseStdIn :: Parser EitherInput
parseStdIn = parseFlag StdInput "stdin" 's' "Read from stdin"


parseOutputFile :: Parser Text
parseOutputFile = parseString "output" 'o'
  "OUTPUT" "Output file name; if not set, write to stdout"


parseEitherOutput :: Parser EitherOutput
parseEitherOutput = f <$> optional parseOutputFile
  where
    f (Just text) = FileOutput text
    f Nothing     = StdOutput
