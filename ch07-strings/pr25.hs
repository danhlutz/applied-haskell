#!/usr/bin/env sack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Text.Encoding as TE

main = do
  let text = "This is some text wiht non-latin chars: שלום"
      bs = TE.encodeUtf8 text
  B.writeFile "content.txt" bs
  text2 <- TIO.readFile "content.txt"
  TIO.putStrLn text2
