{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Json.Merge.ArgParser
  ( Args(..)
  , args
  , InputFile(..)
  , InsertOption(..)
  , MergeOption(..)
  ) where

import           RIO
import           Options.Applicative

import           My.Plot.Common
import           My.Plot.Json.Common


newtype InputFile
  = InputFile
  { inputFile :: FileName
  } deriving (Show, Eq)


newtype MergeOption
  = MergeOption
  { mergeOptionFile :: JsonFile
  } deriving (Show, Eq)


data InsertOption
  = InsertOption
  { insertOptionKey   :: FieldKey
  , insertOptionValue :: FieldValue
  } deriving (Show, Eq)

data Args = Args
  { argsInput   :: InputFile
  , argsOutput  :: EitherOutput
  , argsRemove  :: Maybe RemoveOption
  , argsInsert  :: Maybe InsertOption
  , argsMerge   :: Maybe EitherInput
  } deriving (Show, Eq)


args :: IO Args
args = execParser parserWithInfo


parserWithInfo :: ParserInfo Args
parserWithInfo = info (argsParser <**> helper)
  (  fullDesc
  <> header "A json file manipulator for plot."
  )


argsParser :: Parser Args
argsParser = Args
  <$> parseInput
  <*> parseEitherOutput
  <*> optional parseRemoveOption
  <*> optional parseInsertOption
  <*> optional parseMerge


parseInput :: Parser InputFile
parseInput
  =   InputFile
  <$> parseString "file" 'f' "FILE" "Input File"


parseInsertOption :: Parser InsertOption
parseInsertOption
  =   InsertOption
  <$> parseString "key"   'k' "KEY"   "Insert KEY"
  <*> parseString "value" 'v' "VALUE" "Insert Value"


parseMerge :: Parser EitherInput
parseMerge
  =   FileInput
  <$> parseString "merge" 'm' "MERGE" "Json file to which merge"
  <|> parseStdIn
