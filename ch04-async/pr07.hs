#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE FlexibleContexts #-}
import Control.Concurrent
import Control.Concurrent.Async
import Control.Exception
import Control.Monad.Reader
import Control.Monad.Trans.Control

counter :: IO a
counter =
  let loop i = do
        putStrLn $ "counter: " ++ show i
        threadDelay 100000
        loop $! i + 1
  in loop 1

withCounter :: MonadBaseControl IO m => m a -> m a
withCounter inner = control $ \runInIO -> do
  res <- race counter (runInIO inner)
  case res of
    Left x -> assert False x
    Right x -> return x

main :: IO ()
main = do
  putStrLn "before withCounter"
  threadDelay 2000000
  flip runReaderT "some string" $ withCounter $ do
    liftIO $ threadDelay 2000000
    str <- ask
    liftIO $ putStrLn $ "inside withCounter, str = " ++ str
    liftIO $ threadDelay 2000000
  threadDelay 2000000
  putStrLn "after withCounter"
  threadDelay 2000000
  putStrLn "Exiting"
