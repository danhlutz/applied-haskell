#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import Data.Monoid ((<>))

main :: IO ()
main = do
  let fp = "somefile.txt"
  B.writeFile fp $ "Hello " <> "World!"
  contents <- B.readFile fp
  B8.putStr $ B8.takeWhile (/= ' ') contents
