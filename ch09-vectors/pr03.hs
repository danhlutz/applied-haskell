#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import qualified Data.Vector as V

main :: IO ()
main = do
  let list = [1..10] :: [Int]
      vector = V.fromList list :: V.Vector Int
      vector2 = V.enumFromTo 1 10 :: V.Vector Int
  print $ vector == vector2
  print $ list == V.toList vector
  print $ V.filter odd vector
  print $ V.map (* 2) vector
  print $ V.zip vector vector
  print $ V.zipWith (*) vector vector
  print $ V.reverse vector
  print $ V.takeWhile (< 6) vector
  print $ V.takeWhile odd vector
  print $ V.takeWhile even vector
  print $ V.dropWhile (< 6) vector
  print $ V.head vector
  print $ V.tail vector
  print $ V.head $ V.takeWhile even vector
