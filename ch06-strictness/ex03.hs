{-# LANGUAGE BangPatterns #-}
module Main where

data StrictList a = Cons !a !(StrictList a) | Nil

strictMap :: (a -> b) -> StrictList a -> StrictList b
strictMap _ Nil = Nil
strictMap f (Cons a list) =
  let !b = f a
      !list' = strictMap f list
  in b `seq` list' `seq` Cons b list'

strictEnum :: Int -> Int -> StrictList Int
strictEnum low high =
  go low
  where
    go !x
      | x == high = Cons x Nil
      | otherwise = Cons x (go $! x + 1)

double :: Int -> Int
double !x = x * 2

evens :: StrictList Int
evens = strictMap double $! strictEnum 1 1000000

main :: IO ()
main = do
  let string = "Hello world"
      -- part 3: max res: 40 MB
      -- !string' = evens `seq` string
      string' = evens `seq` string
  -- part 1: max Res: 44 KB
  -- putStrLn string
  -- part 2: max Res: 40 MB
  -- putStrLn string'
  -- putStrLn string
  -- part 4: max res: 40 MB
  evens `seq` putStrLn string
