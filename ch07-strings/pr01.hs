#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as S
import           Data.Monoid ((<>))
import           Data.Word (Word8)

main :: IO ()
main = do
  S.writeFile "content.txt" "this is some sample content"
  bs <- S.readFile "content.txt"
  print bs
  print $ S.takeWhile (/= space) bs
  print $ S.take 5 bs
  print $ "File contents " <> bs

  putStrLn $ "Largest byte: " ++ show (S.foldl1' max bs)

  putStrLn $ "Spaces: " ++ show (S.length (S.filter (==space) bs))

  where
    space :: Word8
    space = 32
