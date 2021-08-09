#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE BangPatterns #-}

main :: IO ()
main = print $ loop 0 1
  where loop !total i
          | i > 100 = total
          | otherwise = loop (total + 1) (i+1)
