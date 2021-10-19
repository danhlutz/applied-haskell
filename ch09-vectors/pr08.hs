#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.Vector.Algorithms.Merge (sort)
import qualified Data.Vector.Generic.Mutable as M
import qualified Data.Vector.Unboxed as V
import           System.Random (randomRIO)

main :: IO ()
main = do
  vector <- M.replicateM 100 $ randomRIO (0, 999 :: Int)
  sort vector
  V.unsafeFreeze vector >>= print
