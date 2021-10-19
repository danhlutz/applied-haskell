#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Vector.Algorithms.Merge (sort)
import qualified Data.Vector.Unboxed as V
import           System.Random (randomRIO)

main :: IO ()
main = do
  vector <- V.replicateM 100 $ randomRIO (0, 100000 :: Int)
  print $ V.modify sort vector
