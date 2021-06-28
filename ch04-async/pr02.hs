#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Applicative
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
  res1 <- runConcurrently $ (,)
      <$> Concurrently action1
      <*> Concurrently action2
  print (res1 :: (Int, String))

  res2 <- runConcurrently $
          (Left <$> Concurrently action1)
      <|> (Right <$> Concurrently action2)
  print (res2 :: Either Int String)
