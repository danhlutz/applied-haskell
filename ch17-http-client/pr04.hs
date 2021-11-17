#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import Network.HTTP.Simple

main = do
  response <- httpLBS "BAD URL"
  print response
