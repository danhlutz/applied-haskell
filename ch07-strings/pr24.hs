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
  bs2 <- B.readFile "content.txt"
  let text2 = TE.decodeUtf8 bs2
  TIO.putStrLn text2
