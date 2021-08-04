#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Monad (forever)
import Say (say)
import Data.Text (Text)

data Work = Work Text

jobQueue :: TChan Work -> IO a
jobQueue chan = forever $ do
  Work t <- atomically $ readTChan chan
  say t

main :: IO ()
main = do
  chan <- newTChanIO
  a <- async $ jobQueue chan
  link a
  forever $ do
    atomically $ do
      writeTChan chan $ Work "Hello"
      writeTChan chan $ Work undefined
      writeTChan chan $ Work "World"
    threadDelay 1000000
