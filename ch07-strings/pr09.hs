#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as S
import qualified Data.Text.IO as TIO
import qualified Data.Text.Encoding as TE

main :: IO ()
main = do
  S.writeFile "utf8-file.txt" $ TE.encodeUtf8 "hello hola שלום"
  text <- TIO.readFile "utf8-file.txt"
  print text
