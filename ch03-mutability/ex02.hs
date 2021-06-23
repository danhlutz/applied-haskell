#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad (forever)
import Say

main :: IO ()
main = do
  aliceVar <- newTVarIO 0
  bobVar <- newTVarIO 0

  _ <- forkIO $ payAlice aliceVar

  atomically $ do
    currentAlice <- readTVar aliceVar
    check' (currentAlice >= 20)
    writeTVar aliceVar (currentAlice - 20)
    currentBob <- readTVar bobVar
    writeTVar bobVar (currentBob + 20)

  finalAlice <- atomically $ readTVar aliceVar
  finalBob <- atomically $ readTVar bobVar

  sayString $ "Final Alice: " ++ show finalAlice
  sayString $ "Final Bob: " ++ show finalBob

payAlice :: TVar Int -> IO ()
payAlice aliceVar = forever $ do
  threadDelay 1000000
  atomically $ do
    current <- readTVar aliceVar
    writeTVar aliceVar (current + 5)
  sayString "Paid Alice"


check' :: Bool -> STM ()
check' b = if b then return () else retry
