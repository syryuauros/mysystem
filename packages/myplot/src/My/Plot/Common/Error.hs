{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Common.Error where

import           RIO
import qualified Data.Text.IO                     as T

import           My.Plot.Common.Types


{-| My Error Types for whole app

-}
data MyErr
 = FileErr FileErr
 | JsonErr JsonErr

newtype FileErr
  = FileAlreadyExists FileName

data JsonErr
  = JsonIsNotArray
  | JsonDecodeFail FileName
  | JsonNeitherNumberNorString Text


{-| Function to report after running the ExceptT monad

-}
reportMyErr :: Either MyErr () -> IO ()
reportMyErr (Right _) = pure ()
reportMyErr (Left e) = T.putStrLn $ "ERROR: " <> render e
  where
    render (JsonErr err) = renderJsonErr err
    render (FileErr err) = renderFileErr err


renderJsonErr :: JsonErr -> Text
renderJsonErr = \case
  JsonIsNotArray                  -> "Json is not an array"
  JsonDecodeFail file             -> "Failed to decode " <> file
  JsonNeitherNumberNorString txt -> txt <> " is neither number nor string"


renderFileErr :: FileErr -> Text
renderFileErr = \case
  FileAlreadyExists file   -> file <> " already exists. please rename it"
