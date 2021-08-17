#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Data.ByteString (ByteString)
import qualified Data.ByteString.Char8 as B8

main :: IO ()
main = do
  let bs = "Non Latin chars: שלום"
  B8.putStrLn bs
  print bs
