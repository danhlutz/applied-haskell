#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
import RIO
import Prelude (print)
import System.Random (randomRIO)

main :: IO ()
main = do
  var <- newMVar (0 :: Int)
  replicateConcurrently_ 1000 (inner var)
  takeMVar var >>= print
  where
    inner var = modifyMVar_ var $ \val -> do
      x <- randomRIO (1, 10)
      return $! val + x
