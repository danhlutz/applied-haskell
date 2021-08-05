#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO
import Test.Hspec
import Control.Monad (replicateM)

data App = App
  { appCounter :: !(TVar Int) }

expensiveComp :: RIO App Int
expensiveComp = do
  app <- ask
  delayVar <- registerDelay 1000000
  atomically $ do
    readTVar delayVar >>= checkSTM
    let var = appCounter app
    modifyTVar' var (+1)
    readTVar var

main :: IO ()
main = hspec $ it "works" $ do
  app <- App <$> newTVarIO 0
  res <- runRIO app $ replicateConcurrently 10 expensiveComp
  sum res `shouldBe` sum [1..10]
