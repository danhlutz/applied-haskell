#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as S
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE

main :: IO ()
main = do
  let text = "This is some text, with non-latin characters: שלום"
      bs = TE.encodeUtf8 text
  S.writeFile "content.txt" bs
  bs2 <- S.readFile "content.txt"
  let text2 = TE.decodeUtf8 bs2
  print text2
