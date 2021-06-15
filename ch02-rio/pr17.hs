#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp $ do
  result <- tryIO $ readFileUtf8 "does-not-exist"
  case result of
    Left e -> logError $ "Error reading file: " <> displayShow e
    Right text -> logInfo $ "That's surprising ... " <> display text
