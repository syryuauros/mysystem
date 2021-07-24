{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     GADTs
                 #-}

module My.Plot.Common.Types where

import           RIO
import           Control.Monad.Except             ( ExceptT )

type EIO e = ExceptT e IO

type FileName = Text
type JsonFile   = Text
type FieldKey   = Text
type FieldValue = Text

data EitherInput
  = FileInput Text
  | StdInput
  deriving (Show, Eq)

data EitherOutput
  = FileOutput Text
  | StdOutput
  deriving (Show, Eq)
