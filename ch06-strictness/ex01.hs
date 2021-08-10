{-# LANGUAGE BangPatterns #-}
module Main where


mySum :: [Int] -> Int
mySum list0 = go list0 0
  where
    go [] total = total
    -- with $!: max residency 44KB
    -- go (x:xs) total = go xs $! total + x
    -- with Bang: max residency 44KB
    -- go (x:xs) !total = go xs (total +x)
    -- with seq
    go (x:xs) total =
      let newTotal = total + x
      in newTotal `seq` go xs newTotal

main :: IO ()
main = print $ mySum [1..1000000]

-- max residency
-- before using $!
-- 51MB
-- after $!
-- 44KB
-- with a Bang Pattern
