{-# LANGUAGE BangPatterns#-}
module Main where

import Control.DeepSeq

data RunningTotal = RunningTotal
  { sum' :: Int
  , count :: Int }
instance NFData RunningTotal where
  rnf (RunningTotal sum count) = sum `deepseq` count `deepseq` ()

deepseq' :: NFData a => a -> b -> b
deepseq' x y = rnf x `seq` y

printAverage :: RunningTotal -> IO ()
printAverage (RunningTotal s c)
  | c == 0 = error "Need at least one val!"
  | otherwise = print (fromIntegral s / fromIntegral c :: Double)

printListAverage :: [Int] -> IO ()
printListAverage =
  go (RunningTotal 0 0)
  where go rt [] = printAverage rt
        go (RunningTotal sum count) (x:xs) =
          let
            rt = RunningTotal (sum + x) (count +1)
          in rt `deepseq'` go rt xs

main :: IO ()
main = printListAverage [1..1000000]
