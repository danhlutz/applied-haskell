#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

oneSecond, fiveSeconds :: Int
oneSecond = 1000000
fiveSeconds = 5000000

main :: IO ()
main = runSimpleApp $ do
  res <- timeout oneSecond $ do
    logInfo "Inside the timeout"
    res <- tryAny $ threadDelay fiveSeconds `finally`
      logInfo "Inside the finally"
    logInfo $ "Result: " <> displayShow res
  logInfo $ "After timeout: " <> displayShow res
