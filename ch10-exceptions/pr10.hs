#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp $ do
  result1 <- tryAny $ error "this will be caught"
  case result1 of
    Left _ -> logInfo "Exception was caught"
    Right () -> logInfo "How was this successful?!"

  result2 <- tryAny $ pure $ error "This will escape!"
  case result2 of
    Left _ -> logInfo "Exception was caught"
    Right () -> logInfo "How was this successful!"
