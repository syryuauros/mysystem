{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Json.Common where


import           RIO
import           Options.Applicative
import           Data.Aeson                       ( Value )
import           Control.Monad.Except             ( liftEither )

import           My.Plot.Common


newtype RemoveOption
  = RemoveOption
  { removeOptionKey :: FieldKey
  } deriving (Show, Eq)


parseRemoveOption :: Parser RemoveOption
parseRemoveOption
  =   RemoveOption
  <$> parseString "remove" 'r' "KEY" "Remove KEY"


mayRemove :: Maybe RemoveOption -> Value -> EIO JsonErr Value
mayRemove opt jv = case opt of
  Nothing                 -> return jv
  Just (RemoveOption key) -> liftEither $ removeField key jv
