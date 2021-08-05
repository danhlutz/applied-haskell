#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Monad (forever)
import Say (say)
import Data.Text (Text)
import Control.Monad.Reader

data Work = Work Text

jobQueue :: ReaderT (TChan Work) IO a
jobQueue = forever $ do
  chan <- ask
  Work t <- liftIO $ atomically $ readTChan chan
  say t

inner :: ReaderT (TChan Work) IO ()
inner = ReaderT $ \chan -> do
  race_ (runReaderT jobQueue chan) $ flip runReaderT chan $ do
    forever $ do
      chan' <- ask
      liftIO $ atomically $ do
        writeTChan chan' $ Work "Hello"
        writeTChan chan' $ Work undefined
        writeTChan chan' $ Work "World"
      liftIO $ threadDelay 1000000

main :: IO ()
main = do
  chan <- newTChanIO
  runReaderT inner chan
