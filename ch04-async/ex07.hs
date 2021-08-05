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

main :: IO ()
main = hspec $ it "works" $ do
  res <- forConcurrently [1..10] expensiveComp
  res `shouldBe` [1..10]
