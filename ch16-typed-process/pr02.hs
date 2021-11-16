#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = do
  let dateConfig :: ProcessConfig () () ()
      dateConfig = proc "date" []
  process <- startProcess dateConfig
  exitCode <- waitExitCode (process :: Process () () ())
  print exitCode

  stopProcess process
