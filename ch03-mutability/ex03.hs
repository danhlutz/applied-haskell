#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE BangPatterns #-}
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
  modTVarLaz toVar (+amount)

modifyTVarStrict :: TVar a -> (a -> a) -> STM ()
modifyTVarStrict var f = do
  x <- readTVar var
  let !new = f x
  writeTVar var new

modTVarLaz :: TVar a -> (a -> a) -> STM ()
modTVarLaz var f = readTVar var >>= \x -> writeTVar var (f x)
