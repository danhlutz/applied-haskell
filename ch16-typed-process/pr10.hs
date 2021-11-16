#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed
import System.IO

main :: IO ()
main = do
  let catConfig = setStdin createPipe
                $ setStdout createPipe
                $ setStderr closed
                  "cat"
  withProcess_ catConfig $ \p -> do
    hPutStrLn (getStdin p) "Hello!"
    hFlush (getStdin p)
    hGetLine (getStdout p) >>= print

    hClose (getStdin p)
