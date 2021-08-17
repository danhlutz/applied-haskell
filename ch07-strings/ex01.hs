#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import System.IO
import System.Environment (getArgs)
import Data.Monoid ((<>))

countChunk :: Handle -> Int -> IO Int
countChunk hndl count = do
  bs <- B.hGetSome hndl 4096
  if B.null bs then return count else do
    let newCount = countLines bs
    countChunk hndl (newCount + count)

countLines :: B.ByteString -> Int
countLines = B8.length . B8.filter (== '\n')

main :: IO ()
main = do
  (filename:_) <- getArgs
  count <- withBinaryFile filename ReadMode (\hIn -> countChunk hIn 0)
  print $ "lines: " ++ show count
