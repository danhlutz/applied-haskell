#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE BangPatterns #-}

add' :: Int -> Int -> Int
add' x y =
  let part1 = seq x part2
      part2 = seq y answer
      answer = x + y
  in part1

add :: Int -> Int -> Int
add x y = x `seq` y `seq` x + y

main :: IO ()
main = do
  let five = add (1+1) (1+2)
      seven = add (1+2) (1+3)
  five `seq` seven `seq` putStrLn ("Five: " ++ show five)
