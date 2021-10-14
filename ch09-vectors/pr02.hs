#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import qualified Data.Vector.Unboxed as V

main :: IO ()
main = print $ V.sum $ V.enumFromTo 1 (10^2 :: Int)
