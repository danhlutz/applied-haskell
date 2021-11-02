#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp $ do
  let fp = "myfile.txt"
  message <- readFileUtf8 fp `catchIO` \e -> do
    logWarn $ "Could not open " <> fromString fp <> ": " <> displayShow e
    pure "This is the default message"
  logInfo $ display message
