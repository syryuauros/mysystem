{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
           ,     RecordWildCards
                 #-}

module My.Plot.Json.Filter
  ( jsonFilter
  ) where


import           RIO
import           Data.Aeson                       ( Value )
import           Data.Aeson.Types                 ( Object )
import           Control.Lens                     ( at )
import           Control.Monad.Except             ( runExceptT
                                                  , liftEither
                                                  , withExceptT
                                                  )

import           My.Plot.Common
import qualified My.Plot.Common.MParser           as M
import           My.Plot.Json.Common
import           My.Plot.Json.Filter.ArgParser    ( Args(..)
                                                  , args
                                                  , MinMaxFilter(..)
                                                  )


{-

ex) json-filter --key epoch --min 100 --max 300 --invert

-}

jsonFilter :: IO ()
jsonFilter = do

  Args{..} <- args

  runExceptT
    (         withExceptT FileErr ( eitherOutputExists     argsOutput )
    >>        withExceptT JsonErr ( readJsonEitherInput    argsInput
                                >>= mayRemove              argsRemove
                                >>= mayFilter              argsFilter )
    >>= \v -> withExceptT FileErr ( writeValueEitherOutput argsOutput v )
    )
  >>= reportMyErr



mayFilter :: Maybe MinMaxFilter -> Value -> EIO JsonErr Value
mayFilter opt jv = case opt of
  Nothing                       -> return jv
  Just (MinMaxFilter key mn mx) -> liftEither $ mmFilter key mn mx jv


mmFilter :: Text -> Text -> Text -> Value -> Either JsonErr Value
mmFilter key mn mx = patchValue (between key mn mx)


between :: Text -> Text -> Text -> [Object] -> [Object]
between key mn mx
  = filter (\x -> let v = x ^. at key
                  in v >= a && v <= b)
  where
    a = rightToMaybe $ M.parse M.valueNumberOrString ""  mn
    b = rightToMaybe $ M.parse M.valueNumberOrString ""  mx
    rightToMaybe = either (const Nothing) Just
