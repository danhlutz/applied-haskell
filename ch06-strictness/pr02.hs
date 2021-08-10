#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE BangPatterns #-}

add :: Int -> Int -> Int
add !x !y = x + y

main :: IO ()
main = do
  let !five = add (1+1) (1+2)
      seven = add (1+2) undefined
  putStrLn $ "Five: " ++ show five
