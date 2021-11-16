#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed
import System.IO
import UnliftIO.Temporary (withSystemTempFile)

main :: IO ()
main = withSystemTempFile "input" $ \fp h -> do
  hPutStrLn h "Hello world!"
  hClose h

  withBinaryFile fp ReadMode $ \h' ->
    runProcess_ $ setStdin (useHandleClose h') "cat"
