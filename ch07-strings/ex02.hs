#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import System.IO
import System.Environment (getArgs)
import Data.Monoid ((<>))

longer :: B.ByteString -> B.ByteString -> B.ByteString
longer xs ys =
  if B.length xs > B.length ys
  then xs else ys

longest :: [B.ByteString] -> B.ByteString
longest = foldr longer B.empty

main :: IO ()
main = do
  (filename:_) <- getArgs
  contents <- B.readFile filename
  let result = longest $ B8.lines contents
  print $ "Longest line: " <> result

