#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Control.Monad (replicateM_)
import           Data.Vector.Unboxed (freeze)
import qualified Data.Vector.Unboxed.Mutable as V
import           System.Random (randomRIO)

main :: IO ()
main = do
  vector <- V.replicate 10 (0 :: Int)

  replicateM_ (10^6) $ do
    i <- randomRIO (0,9)
    oldCount <- V.read vector i
    V.write vector i (oldCount + 1)

  ivector <- freeze vector
  print ivector
