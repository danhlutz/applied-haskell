#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import System.IO
import System.Environment (getArgs)
import Data.Monoid ((<>))

countLines :: B.ByteString -> Int
countLines = B8.length . B8.filter (== '\n')

main :: IO ()
main = do
  (filename:_) <- getArgs
  content <- B.readFile filename
  print $ "# lines: " ++ show (countLines content)
