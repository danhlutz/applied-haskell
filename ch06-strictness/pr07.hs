{-# LANGUAGE BangPatterns #-}
module Main where

import Data.List (foldl')

myfoldl :: (b -> a -> b) -> b -> [a] -> b
myfoldl _ b []     = b
myfoldl f b (x:xs) =
  let !b' = f b x
  in myfoldl f b' xs

mySum :: [Int] -> Int
mySum =
  -- with foldl: residency - 56 MB
  -- foldl (+) 0
  -- with myfoldl : residency - 44 KB
  -- myfoldl (+) 0
  -- with foldl' : residency - 44 KB
  foldl' (+) 0

main :: IO ()
main = print $ mySum [1..1000000]
