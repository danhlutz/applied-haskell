module Main where

import Data.List (foldl')
import Control.DeepSeq (force)

average :: [Int] -> Double
average =
  divide . foldl' add (0,0)
  where
    divide (t, c) = fromIntegral t / c
    -- before force: 72 MB res
    -- add (t,c) x = (t + x, c +1)
    -- after force: 44 KB
    add (t,c) x = force (t +x, c+1)

main :: IO ()
main = print $ average [1..1000000]
