#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp $ do
  logInfo "This will print first"
    `onException` logInfo "this will never print"
  throwString "This will print last as an error"
    `finally` logInfo "This will print second"
  logInfo "This will never print"
