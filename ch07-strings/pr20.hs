#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}
import Data.Text (Text)
import qualified Data.Text as T

input :: Text
input = "Alice,165cm,30y,15\n\
        \Bob,170cm,35y,-20\n\
        \Charlie,175cm,40y,0\n"

parseRow :: Text -> [Text]
parseRow = T.splitOn ","

main :: IO ()
main = mapM_ print $ map parseRow $ T.lines input
