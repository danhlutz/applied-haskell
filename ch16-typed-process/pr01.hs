#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.IO (hPutStr, hClose)
import System.Process.Typed
import qualified Data.ByteString.Lazy as L
import qualified Data.ByteString.Lazy.Char8 as L8
import Control.Concurrent.STM (atomically)
import Control.Exception (throwIO)

main :: IO ()
main = do
  runProcess "true" >>= print
  runProcess "false" >>= print

  runProcess_ "true"

  (dateOut, dateErr) <- readProcess_ "date"
  print (dateOut, dateErr)

  (dateOut2, dateErr2) <- readProcess_ "date >&2"
  print (dateOut2, dateErr2)

  let catConfig = setStdin createPipe
                $ setStdout byteStringOutput
                $ proc "cat" ["/etc/hosts", "-", "/etc/group"]

  withProcessWait_ catConfig $ \p -> do
      hPutStr (getStdin p) "\n\nHELLO\n"
      hPutStr (getStdin p) "WORLD\n\n\n"
      hClose (getStdin p)

      atomically (getStdout p) >>= L8.putStr
