#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import qualified Data.ByteString.Lazy as BL
import qualified Data.ByteString.Lazy.Char8 as BL8
import UnliftIO.Exception (pureTry)

main :: IO ()
main = do
  let bomb = concat $ replicate 10000 "hello " ++ [undefined]
  print $ pureTry $ take 5 bomb
  print $ pureTry $ B.take 5 $ B8.pack bomb
  print $ pureTry $ BL.take 5 $ BL8.pack bomb
