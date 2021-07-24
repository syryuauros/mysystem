{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Json.Filter.ArgParser
  ( Args(..)
  , args
  , MinMaxFilter(..)
  ) where

import           RIO
import           Options.Applicative

import           My.Plot.Common                   ( EitherInput
                                                  , EitherOutput
                                                  , FieldKey
                                                  , FieldValue
                                                  , parseString
                                                  , parseEitherInput
                                                  , parseEitherOutput
                                                  )
import           My.Plot.Json.Common              ( RemoveOption
                                                  , parseRemoveOption
                                                  )


data MinMaxFilter = MinMaxFilter
  { filtersKey  :: FieldKey
  , filtersMin  :: FieldValue
  , filtersMax  :: FieldValue
  } deriving (Show, Eq)


data Args = Args
  { argsInput   :: EitherInput
  , argsOutput  :: EitherOutput
  , argsFilter  :: Maybe MinMaxFilter
  , argsRemove  :: Maybe RemoveOption
  } deriving (Show, Eq)


args :: IO Args
args = execParser parserWithInfo


parserWithInfo :: ParserInfo Args
parserWithInfo = info (argsParser <**> helper)
  (  fullDesc
  <> header "A json filter for plot."
  )


argsParser :: Parser Args
argsParser = Args
  <$> parseEitherInput
  <*> parseEitherOutput
  <*> optional parseMinMaxFilter
  <*> optional parseRemoveOption


parseMinMaxFilter :: Parser MinMaxFilter
parseMinMaxFilter
  =   MinMaxFilter
  <$> parseString "key" 'k' "KEY" "Key for whose values to filter"
  <*> parseString "min" 'a' "MIN" "Larger than this value survive"
  <*> parseString "max" 'b' "MAX" "Smaller than this value survive"
