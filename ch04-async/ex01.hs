#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import Control.Concurrent
import Control.Concurrent.Async
import Control.Exception
import           Data.Text (Text)
import qualified Data.Text as T
import Data.Text.IO as TIO

action1 :: IO Int
action1 = error "action1 errored"

action2 :: IO Text
action2 = handle onErr $ do
  threadDelay 500000
  return "action2 completed"
  where
    onErr e = do
      TIO.putStrLn $ T.pack ("action2 was killed by: " ++ displayException e)
      throwIO (e :: SomeException)

main :: IO ()
main = do
  res <- concurrently action1 action2
  print res
