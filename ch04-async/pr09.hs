#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Monad
import Say

getResult :: IO Int
getResult = do
  sayString "Doing Some big computation"
  threadDelay 2000000
  sayString "Done!"
  return 42

main :: IO ()
main = withAsync getResult $ \a -> do
  res <- atomically $ pollSTM a

  case res of
    Nothing -> sayString "getResult still running"
    Just (Left e) -> sayString $ "getResult failed: " ++ show e
    Just (Right x) -> sayString $ "getResult finished 1: " ++ show x

  res <- atomically $ waitCatchSTM a
  case res of
    Left e -> sayString $ "getResult failed: " ++ show e
    Right x -> sayString $ "getResult finished 2: " ++ show x

  res <- atomically $ waitSTM a
  sayString $ "getResult finished 3: " ++ show res
