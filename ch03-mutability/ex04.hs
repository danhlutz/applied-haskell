#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Concurrent.STM
import Control.Monad (replicateM_)
import System.IO.Unsafe (unsafePerformIO)

callCount :: IO (TVar Int)
callCount = newTVarIO 0
{-# NOINLINE callCount #-}

someFunction :: TVar Int -> IO ()
someFunction tv = do
  count <- atomically $ do
    modifyTVar tv (+ 1)
    readTVar tv
  putStrLn $ "someFunction call count: " ++ show count

main :: IO ()
main = do
  cc <- callCount
  replicateM_ 10 (someFunction cc)
