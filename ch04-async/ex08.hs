#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO
import Test.Hspec
import Control.Monad (replicateM)

expensiveComp :: MonadIO m => Int -> m Int
expensiveComp input = do
  threadDelay 1000000
  pure input

sumConcurrently :: (a -> IO Int) -> [a] -> IO Int
sumConcurrently f list = do
  items <- mapConcurrently f list
  return $ sum items

sumC' :: (a -> IO Int) -> [a] -> IO Int
sumC' f list = do
  totalVar <- newTVarIO 0
  forConcurrently_ list $ \a -> do
    int <- f a
    atomically $ modifyTVar' totalVar (+ int)
  readTVarIO totalVar

main :: IO ()
main = hspec $ it "works" $ do
  res <- sumC' expensiveComp [1..10]
  res `shouldBe` sum [1..10]
