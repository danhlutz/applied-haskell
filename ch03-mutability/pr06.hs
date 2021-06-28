#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Applicative ((<|>))
import Control.Concurrent
import Control.Concurrent.STM
import Control.Monad (forever, void)
import Say

main :: IO ()
main = do
  aliceVar <- newTVarIO 0
  bobVar <- newTVarIO 0
  charlieVar <- newTVarIO 0

  payThread aliceVar 1000000 5
  payThread bobVar 1500000 8

  atomically $ transfer 20 aliceVar charlieVar
           <|> transfer 20 bobVar charlieVar

  finalAlice <- readTVarIO aliceVar
  finalBob <- readTVarIO bobVar
  finalCharlie <- readTVarIO charlieVar

  sayString $ "Final alice: " ++ show finalAlice
  sayString $ "Final Bob: " ++ show finalBob
  sayString $ "Final Charlie: " ++ show finalCharlie

payThread :: TVar Int -> Int -> Int -> IO ()
payThread var interval amount = void $ forkIO $ forever $ do
  threadDelay interval
  atomically $ do
    current <- readTVar var
    writeTVar var (current + amount)

transfer :: Int -> TVar Int -> TVar Int -> STM ()
transfer amount fromVar toVar = do
  currentFrom <- readTVar fromVar
  check (currentFrom >= amount)
  writeTVar fromVar (currentFrom - amount)
  currentTo <- readTVar toVar
  writeTVar toVar (currentTo + amount)

