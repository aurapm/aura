{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# LANGUAGE OverloadedStrings #-}

module SrcInfoParser (srcInfoData,
                      SrcInfo(..),
                      lineParser,
                      Line(..),
                      parseConfig,
                      parseSingleLine,
                      combineJustList,
                      add,
                      merge) where

import Data.Text
import Data.Int
import Data.Eq
import Data.Maybe
import Data.Functor
import Text.Megaparsec
import Text.Megaparsec.String
import Data.String
import Data.List
import qualified Text.Megaparsec.Lexer as L
import BasicPrelude
import Prelude

data SrcInfo = SrcInfo { name        :: Maybe Text
                       , version     :: Maybe Text
                       , release     :: Maybe Int
                       , epoch       :: Maybe Text
                       , arch        :: Maybe [Text]
                       , licenses    :: Maybe [Text]
                       , makeDepends :: Maybe [Text]
                       , provides    :: Maybe [Text]
                       , conflicts   :: Maybe [Text]
                       , sources     :: Maybe [Text]
                       , md5sums     :: Maybe [Text]
                       , sha1sums    :: Maybe [Text]
                       , sha224sums  :: Maybe [Text]
                       , sha256sums  :: Maybe [Text]
                       , sha384sums  :: Maybe [Text]
                       , sha512sums  :: Maybe [Text]
                       } deriving (Eq, Show)

srcInfoData :: SrcInfo
srcInfoData = SrcInfo { name        = Nothing
                      , version     = Nothing
                      , release     = Nothing
                      , epoch       = Nothing
                      , arch        = Nothing
                      , licenses    = Nothing
                      , makeDepends = Nothing
                      , provides    = Nothing
                      , conflicts   = Nothing
                      , sources     = Nothing
                      , md5sums     = Nothing
                      , sha1sums    = Nothing
                      , sha224sums  = Nothing
                      , sha256sums  = Nothing
                      , sha384sums  = Nothing
                      , sha512sums  = Nothing
                      }

data Line = Line { parameter :: String
                 , value     :: String
                 } deriving (Eq, Show)

type Lines = [Line]

skip :: Parser ()
skip = L.space (void spaceChar) commentLine commentLine
  where commentLine  = L.skipLineComment "#"

lexeme :: Parser a -> Parser a
lexeme = L.lexeme skip

rightValue = some (alphaNumChar <|> char '>' <|> char '.' <|> char '=' <|> char '<' <|> char '/' <|> char '#' <|> char '-' <|> char '+' <|> char ':' <|> char '_')

lineParser :: Parser Line
lineParser = do
  _ <- lexeme (many (char ' ' <|> char '\t'))
  name <- lexeme (some alphaNumChar)
  _ <- char '='
  _ <- many (char ' ')
  value <- lexeme rightValue
  return Line {parameter = name, value = value}

parseSingleLine :: String -> Line
parseSingleLine x = do
  let parsed = parseMaybe lineParser x
  Data.Maybe.fromMaybe (Line "" "") parsed

convertLineToSrcInfo :: Line -> SrcInfo
convertLineToSrcInfo l =
  case parameter l of
    "pkgbase" -> srcInfoData { name = Just (pack (value l))}
    "pkgver" -> srcInfoData { version = Just (pack (value l))}
    "pkgrel" -> srcInfoData { release = Just (Prelude.read (value l) :: Int)}
    "epoch" -> srcInfoData { epoch = Just (pack (value l))}
    "arch" -> srcInfoData {arch = Just [pack (value l)]}
    "license" -> srcInfoData {licenses = Just [pack (value l)]}
    "makedepends" -> srcInfoData {makeDepends = Just [pack (value l)]}
    "provides" -> srcInfoData {provides = Just [pack (value l)]}
    "conflicts" -> srcInfoData {conflicts = Just [pack (value l)]}
    "source" -> srcInfoData {sources = Just [pack (value l)]}
    "md5sums" -> srcInfoData {md5sums = Just [pack (value l)]}
    "sha1sums" -> srcInfoData {sha1sums = Just [pack (value l)]}
    "sha224sums" -> srcInfoData {sha224sums = Just [pack (value l)]}
    "sha256sums" -> srcInfoData {sha256sums = Just [pack (value l)]}
    "sha384sums" -> srcInfoData {sha384sums = Just [pack (value l)]}
    "sha512sums" -> srcInfoData {sha512sums = Just [pack (value l)]}
    _ -> srcInfoData

-- Only add them together if 1 side contains Nothing
add :: SrcInfo -> SrcInfo -> SrcInfo
add x y = x { name = value (name x) (name y)
            , version = value (version x) (version y)
            , release = value (release x) (release y)
            , epoch = value (epoch x) (epoch y)
            , arch = combineJustList (arch x) (arch y)
            , licenses = combineJustList (licenses x) (licenses y)
            , makeDepends = combineJustList (makeDepends x) (makeDepends y)
            , provides = combineJustList (provides x) (provides y)
            , conflicts = combineJustList (conflicts x) (conflicts y)
            , sources = combineJustList (sources x) (sources y)
            , md5sums = combineJustList (md5sums x) (md5sums y)
            , sha1sums = combineJustList (sha1sums x) (sha1sums y)
            , sha224sums = combineJustList (sha224sums x) (sha224sums y)
            , sha256sums = combineJustList (sha256sums x) (sha256sums y)
            , sha384sums = combineJustList (sha384sums x) (sha384sums y)
            , sha512sums = combineJustList (sha512sums x) (sha512sums y)
            }
  where value a b =
          case a of
            Just v -> Just v
            Nothing -> b

combineJustList :: Maybe [Text] -> Maybe [Text] -> Maybe [Text]
combineJustList a b =
  case a of
    Nothing -> b
    Just k -> case b of
      Nothing -> Just k
      Just l -> Just (k Data.List.++ l)

merge :: [SrcInfo] -> SrcInfo
merge = BasicPrelude.foldl add srcInfoData

removeEmptyLines :: Line -> Bool
removeEmptyLines line = parameter line /= ""

parseConfig :: String -> SrcInfo
parseConfig input = do
  let rawLines = Prelude.map parseSingleLine (Data.String.lines input)
  -- let lines = BasicPrelude.filter removeEmptyLines rawLines
  let partialConfig = Prelude.map convertLineToSrcInfo rawLines
  merge partialConfig
