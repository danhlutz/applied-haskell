#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = do
  let dateConfig :: ProcessConfig () () ()
      dateConfig = setStdin closed
                 $ setStdout closed
                 $ setStderr closed "date"
  exitCode <- runProcess dateConfig
  print exitCode
