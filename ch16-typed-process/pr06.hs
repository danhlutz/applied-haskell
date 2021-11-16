#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed
import System.Exit (ExitCode)
import Data.ByteString.Lazy (ByteString)

main :: IO ()
main = do
  (out, err) <- readProcess_ "date"
  print (out :: ByteString)
  print (err :: ByteString)
