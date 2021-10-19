#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Monad (replicateM_)
import Data.Vector.Unboxed (freeze)
import qualified Data.Vector.Unboxed.Mutable as M
import System.Random (randomRIO)

main :: IO ()
main = do
  v <- M.replicate 10 (0 :: Int)
  replicateM_ 1000000 $ do
    i <- randomRIO (0,9)
    c <- M.read v i
    M.write v i (c+1)
  final <- freeze v
  print final
