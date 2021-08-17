#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Char8 as B8
import System.IO
import System.Environment (getArgs)
import Data.Monoid ((<>))

copyText :: B.ByteString -> Int -> Handle -> IO ()
copyText _ 0 _ = return ()
copyText bs count handle = do
  B.hPut handle bs
  copyText bs (count - 1) handle

main :: IO ()
main = do
  (filename:_) <- getArgs
  let msg = B8.pack $ ['A'..'Z'] ++ "\n"
  print "Starting to copy ..."
  withBinaryFile filename WriteMode (copyText msg 1000)
  print "Done ... "
