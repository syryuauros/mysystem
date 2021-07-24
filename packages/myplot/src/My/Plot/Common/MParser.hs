{-# LANGUAGE     NoImplicitPrelude
           ,     OverloadedStrings
           ,     LambdaCase
           ,     GADTs
                 #-}

module My.Plot.Common.MParser
  ( Parser
  , parse
  , runParser
  , sc
  , symbol
  , integer
  , string
  , text
  , signedInteger
  , signedFloat
  , signedDouble
  , charLiteral
  , stringLiteral
  , textLiteral
  , valueNumberOrString
  ) where

import           RIO                       hiding ( some
                                                  , many
                                                  , any
                                                  , try
                                                  )
import           RIO.Text                         ( pack )
import           Data.Char                        (isSpace)
import           Data.Aeson                       ( Value(..) )
import           Text.Megaparsec           hiding ( State )
import qualified Text.Megaparsec.Char             as C
import qualified Text.Megaparsec.Char.Lexer       as CL


type Parser = Parsec Void Text


sc :: Parser ()
sc = CL.space
  C.space1
  (CL.skipLineComment "//")
  (CL.skipBlockComment "/*" "*/")


lexeme :: Parser a -> Parser a
lexeme = CL.lexeme sc


symbol :: Text -> Parser Text
symbol = CL.symbol sc


integer :: Parser Integer
integer = lexeme CL.decimal


text :: Parser Text
text = pack <$> string


string :: Parser String
string = some C.alphaNumChar


signedInteger :: Parser Integer
signedInteger = CL.signed sc integer


signedFloat :: Parser Float
signedFloat = CL.signed sc CL.float


signedDouble :: Parser Double
signedDouble = CL.signed sc CL.float


charLiteral :: Parser Char
charLiteral = between (C.char '\'') (C.char '\'') CL.charLiteral


stringLiteral :: Parser String
stringLiteral = C.char '\"' *> manyTill CL.charLiteral (C.char '\"')


textLiteral :: Parser Text
textLiteral = pack <$> stringLiteral


valueNumberOrString :: Parser Value
valueNumberOrString
  =   try (Number <$> CL.scientific <* eof)
  <|> try (String <$> anyLetters   <* eof)
  where
    anyLetters :: Parser Text
    anyLetters = pack <$> many (satisfy (not . isSpace))
