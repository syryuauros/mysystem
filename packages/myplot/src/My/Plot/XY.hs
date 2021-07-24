{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
           ,     RecordWildCards
                 #-}

module My.Plot.XY
  ( xyplot
  ) where

import           ClassyPrelude
import qualified Turtle                           as TT
import qualified Filesystem.Path.CurrentOS        as Path
import           Control.Monad.Except             ( ExceptT(..)
                                                  , runExceptT
                                                  , throwError
                                                  )
import           Data.Aeson                       ( eitherDecode )
import qualified Data.ByteString.Lazy             as LB

import           My.Plot.Common            hiding ( abortExists )
import           My.Plot.XY.ArgParser             ( Args(..)
                                                  , args
                                                  )
import           My.Plot.XY.Types
import           My.Plot.XY.VegaLite              ( writeJson
                                                  , writeHtml
                                                  )

xyplot :: IO ()
xyplot = do

  Args {..} <- args

  let outJson = argsOutput <> ".json"
  let outHtml = argsOutput <> ".html"

  runExceptT (do

    abortExists outJson
    abortExists outHtml

    inputData <- readInputData argsInput argsFormat argsEmbed

    liftIO $ do

      let config = (defXYConfig { xField     = argsXaxis
                                , yField     = argsYaxis
                                , yError     = argsYError
                                , colorField = argsColor
                                , shapeField = argsShape
                                , dashField  = argsDash
                                , xScale     = argsXlog
                                , yScale     = argsYlog
                                })

      writeJson config inputData outJson
      writeHtml config inputData outHtml

    ) >>= report


abortExists :: Text -> EIO XYErr ()
abortExists file = do
  exists <- liftIO . TT.testfile $ Path.fromText file
  when exists $ throwError $ XYErrOutputExists file


report :: Either XYErr () -> IO ()
report (Right _) = pure ()
report (Left e) = putStrLn $ "ERROR: " <> render e
  where
    render XYErrNoPathForStdin       = "Stdin can't be referred to as a data path"
    render XYErrNotImplementYet      = "Not implemented yet"
    render (XYErrOutputExists file)  = file <> " already exists. please rename it"
    render (XYErrJsonDecodeFail msg) = msg


readInputData
  :: EitherInput
  -> InputFormat
  -> DataEmbed
  -> EIO XYErr InputData
readInputData input format = \case
  EmbedPath -> ExceptT . return $ embedPath input
  EmbedData -> embedData input format

embedPath :: EitherInput -> Either XYErr InputData
embedPath = \case
  StdInput       -> Left XYErrNoPathForStdin
  FileInput file -> Right . PathTo $ file

embedData
  :: EitherInput
  -> InputFormat
  -> EIO XYErr InputData
embedData input format = do

  byteString <- liftIO $ do
    case input of
      FileInput file
        -> LB.readFile (unpack file)
      StdInput
        -> LB.getContents

  case format of

    JsonInput -> case eitherDecode byteString of
        Left  msg -> throwError $ XYErrJsonDecodeFail (pack msg)
        Right val -> return . Embeded $ val

    CsvInput -> throwError XYErrNotImplementYet
