{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
           ,     RecordWildCards
                 #-}

module My.Plot.Json.Merge
  ( jsonMerge
  ) where


import           RIO
import           Data.Aeson                       ( Value )
import           Control.Monad.Except             ( runExceptT
                                                  , liftEither
                                                  , withExceptT
                                                  )

import           My.Plot.Common
import           My.Plot.Json.Common
import           My.Plot.Json.Merge.ArgParser     ( Args(..)
                                                  , args
                                                  , InputFile(..)
                                                  , InsertOption(..)
                                                  )

jsonMerge :: IO ()
jsonMerge = do

  Args{..} <- args

  runExceptT
    (         withExceptT FileErr ( eitherOutputExists      argsOutput)
    >>        withExceptT JsonErr ( readInput               argsInput
                                >>= mayRemove               argsRemove
                                >>= mayInsert               argsInsert
                                >>= mayMerge                argsMerge )
    >>= \v -> withExceptT FileErr ( writeValueEitherOutput  argsOutput v )
    )
  >>= reportMyErr


readInput :: InputFile -> EIO JsonErr Value
readInput (InputFile file) = readJsonFile file

mayInsert :: Maybe InsertOption -> Value -> EIO JsonErr Value
mayInsert opt jv = case opt of
  Nothing                     -> return jv
  Just (InsertOption key val) -> liftEither $ insertField key val jv


mayMerge :: Maybe EitherInput -> Value -> EIO JsonErr Value
mayMerge opt jv = case opt of
  Nothing -> return jv
  Just eitherInput -> do
    jv2 <- readJsonEitherInput eitherInput
    liftEither $ mergeJson jv jv2
