#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE RecordWildCards #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Text (Text)
import Data.Vector (Vector)
import Data.Yaml

data Movie = Movie
  { movieTitle    :: !Text
  , movieDirector    :: !Text
  } deriving (Show, Eq)

instance ToJSON Movie where
  toJSON Movie {..} = object
    [ "title" .= movieTitle
    , "director" .= movieDirector ]

instance FromJSON Movie where
  parseJSON = withObject "Movie" $ \o -> Movie
    <$> o .: "title"
    <*> o .: "director"

main :: IO ()
main = do
  let bs = encode
        [ Movie "Star Wars" "George Lucas"
        , Movie "Transformers" "Someone Else"]
  movies <-
    case decodeEither' bs of
      Left exc -> error $ "Could not parse " ++ show exc
      Right movies -> return movies
  let fp = "movies.yaml"
  encodeFile fp (movies :: Vector Movie)
  res <- decodeFileEither fp
  case res of
    Left exc -> error $ "Could not parse file " ++ show exc
    Right movies2
      | movies == movies2 -> mapM_ print movies
      | otherwise -> error "Mismatch"
