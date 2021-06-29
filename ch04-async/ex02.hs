#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Concurrent
import Control.Concurrent.Async
import Control.Exception

action1 :: IO Int
action1 = error "action1 errored"

action2 :: IO String
action2 = handle onErr $ do
    threadDelay 500000
    return "action2 completed"
  where
    onErr e = do
      putStrLn $ "action2 was killed by " ++ displayException e
      throwIO (e :: SomeException)

main :: IO ()
main = do
  res <- race action1 action2
  print res
