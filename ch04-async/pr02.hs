#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Concurrent
import Control.Concurrent.Async

action1 :: IO Int
action1 = do
  threadDelay 500000
  return 5

action2 :: IO String
action2 = do
  threadDelay 1000000
  return "action2 result"

main :: IO ()
main = do
  res <- race action1 action2
  print (res :: Either Int String)
