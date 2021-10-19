#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Control.Monad.Primitive (PrimMonad, PrimState)
import qualified Data.Vector.Unboxed as V
import qualified Data.Vector.Unboxed.Mutable as M
import           System.Random (StdGen, getStdGen, randomR)

shuffleM :: (PrimMonad m, V.Unbox a)
         => StdGen
         -> Int
         -> M.MVector (PrimState m) a
         -> m ()
shuffleM _ i _ | i <= 1 = return ()
shuffleM gen i v = do
  M.swap v i' index
  shuffleM gen' i' v
  where
    (index, gen') = randomR (0, i') gen
    i' = i - 1

shuffle :: V.Unbox a => StdGen -> V.Vector a -> V.Vector a
shuffle gen vector = V.modify (shuffleM gen (V.length vector)) vector

main :: IO ()
main = do
  gen <- getStdGen
  print $ shuffle gen $ V.enumFromTo 1 (20 :: Int)
