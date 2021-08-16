#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text.Encoding as TE

main :: IO ()
main = do
  let bs = "Invalid UTF8 sequence\254\253\252"
  case TE.decodeUtf8' bs of
    Left e -> putStrLn $ "an exception occurred: " ++ show e
    Right txt -> print txt
