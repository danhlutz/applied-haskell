#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import qualified Data.ByteString as S
import qualified Data.ByteString.Char8 as S8
import qualified Data.Text as T

main :: IO ()
main = do
  print $ take 5 letters
  print $ T.take 5 $ T.pack letters
  print $ S.take 5 $ S8.pack letters

  where
    letters = ['h','e','l','l','o',undefined]
