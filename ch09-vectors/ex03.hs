#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Monad (replicateM_)
import Data.Vector.Unboxed ((!), (//))
import qualified Data.Vector.Unboxed as V
import System.Random (randomRIO)

main :: IO ()
main = do
  let v0 = V.replicate 10 (0 :: Int)
  v' <- go 1000000 v0
  print v'
  where
    go 0 v = return v
    go n v = do
      i <- randomRIO (0, 9)
      let c = v ! i
      go (n-1) (v // [(i, c+1)])
