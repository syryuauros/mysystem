{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
           ,     ScopedTypeVariables
           ,     RankNTypes
           ,     DataKinds
                 #-}

module My.Plot.Common
  (
    abortExists
  , myEncodePretty
  , mergeList
  , eitherOutputExists
  , writeValueEitherOutput
  , readJsonEitherInput
  , readJsonStdInput
  , readJsonFile
  , removeField
  , insertField
  , mergeJson
  , peel
  , unPeel
  , patchValue
  , module My.Plot.Common.Types
  , module My.Plot.Common.Error
  , module My.Plot.Common.ArgParser
  ) where

import           RIO
import           RIO.Text                         ( pack, unpack )
import           RIO.ByteString                   ( getContents )
import qualified RIO.ByteString.Lazy              as BL

import qualified Turtle                           as TT
import qualified Filesystem.Path.CurrentOS        as Path
import           Control.Monad.Except

import           Data.Vector                      ( fromList )
import           Data.Aeson                       ( ToJSON(..)
                                                  , Value ( Array
                                                          , Object
                                                          , String
                                                          )
                                                  , eitherDecodeStrict
                                                  , eitherDecodeFileStrict
                                                  )
import           Data.Aeson.Types                 ( Object )
import           Data.Aeson.Lens                  ( values
                                                  , _Object
                                                  )
import           Control.Lens                     ( at
                                                  , sans
                                                  , (?~)
                                                  )
import           Data.Aeson.Encode.Pretty         ( encodePretty'
                                                  , defConfig
                                                  , Config(..)
                                                  , Indent(..)
                                                  )

import           My.Plot.Common.Types
import           My.Plot.Common.Error
import           My.Plot.Common.ArgParser


abortExists :: Text -> EIO FileErr ()
abortExists file = do
  exists <- liftIO . TT.testfile $ Path.fromText file
  when exists $ throwError $ FileAlreadyExists file


myEncodePretty :: ToJSON a => a -> BL.ByteString
myEncodePretty
  = encodePretty' (defConfig { confIndent = Spaces 2 })


readJsonEitherInput :: EitherInput -> EIO JsonErr Value
readJsonEitherInput  = \case
  FileInput file -> readJsonFile file
  StdInput       -> readJsonStdInput


readJsonStdInput :: EIO JsonErr Value
readJsonStdInput = do
  b <- liftIO getContents
  case eitherDecodeStrict b of
    Left  msg -> throwError $ JsonDecodeFail (pack msg)
    Right val -> return val


readJsonFile :: JsonFile -> EIO JsonErr Value
readJsonFile file = do
  (liftIO . eitherDecodeFileStrict) (unpack file) >>= \case
    Left  msg -> throwError $ JsonDecodeFail (pack msg)
    Right val -> return val


eitherOutputExists :: EitherOutput -> EIO FileErr ()
eitherOutputExists = \case
  FileOutput file -> abortExists file
  StdOutput       -> return ()


writeValueEitherOutput :: EitherOutput -> Value -> EIO FileErr ()
writeValueEitherOutput output val = case output of
  FileOutput file -> BL.writeFile (unpack file) pretty
  StdOutput -> liftIO $ BL.putStrLn pretty
  where
    pretty = myEncodePretty val


-- remove all the fields with the key
removeField :: Text -> Value -> Either JsonErr Value
removeField key = patchValue (fmap (sans key))


insertField :: Text -> Text -> Value -> Either JsonErr Value
insertField key label = patchValue (fmap (insert key label))
  where
    insert k l = \x -> x & at k ?~ String l


peel :: Value -> Either JsonErr [Object]
peel = \case
  val@(Array _) -> return $ val ^.. values . _Object
  _             -> throwError JsonIsNotArray


unPeel :: [Object] -> Value
unPeel xs = Array . fromList $ Object <$> xs


mergeJson :: Value -> Value -> Either JsonErr Value
mergeJson v1 v2 = do
  pv1 <- peel v1
  pv2 <- peel v2
  return . unPeel $ mergeList pv1 pv2


{- Merge two lists.

>>> mergeList [1, 2, 3, 4, 5, 6] [10, 20, 30]
[1,10,2,20,3,30,4,5,6]
-}
mergeList :: [a] -> [a] -> [a]
mergeList []     ys = ys
mergeList (x:xs) ys = x:mergeList ys xs


{- Patch the content of the Value type. The Value is assumed to be an Array of Objects,
which is to be converted into a list of Objects. A patching function of type [Object] ->
[Object] acts on the list. The result is wrapped back into the json Value, with possible
error econded in the Either type.

-}
patchValue :: ([Object] -> [Object]) -> Value -> Either JsonErr Value
patchValue f val =
  peel val >>= \list -> return . unPeel $ f list


-- filterValue :: Text -> (Text -> Value -> Bool) -> Value -> Either JsonErr Value
-- filterValue key f
--   = patchValue (filter (\x -> let mayV = x ^. at key
--                               in case mayV of
--                                 Just v  -> f key v
--                                 Nothing -> False))
