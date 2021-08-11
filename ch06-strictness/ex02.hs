{-# LANGUAGE BangPatterns #-}
module Main where

import Conduit
import Control.DeepSeq (force)

data RT = RT !Int !Int

average :: Monad m => ConduitM Int o m Double
average =
  divide <$> foldlC add (RT 0 0)
  where
    divide (RT t c) = fromIntegral t / fromIntegral c
    -- original: RES: 84 MB
    -- add (t,c) x  = (t + x, c + 1)
    -- force:    RES: 44 KB
    -- add (t,c) x = force (t + x, c + 1)
    -- bang:     RES: 44 KB
    -- add (!t,!c) x = (t + x, c + 1)
    -- custom dt RES: 44 KB
    add (RT t c) x = RT (t + x) (c + 1)

main :: IO ()
main = print $ runConduitPure $ enumFromToC 1 1000000 .| average
