#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Control.Monad.ST (ST)
import qualified Data.Vector.Unboxed as V
import qualified Data.Vector.Unboxed.Mutable as M
import           System.Random.MWC (Gen, uniformR, withSystemRandom)

shuffleM  :: V.Unbox a
          => Gen s
          -> Int
          -> M.MVector s a
          -> ST s ()
shuffleM _ i _ | i <= 1 = return ()
shuffleM gen i v = do
  index <- uniformR (0, i') gen
  M.swap v i' index
  shuffleM gen i' v
  where i' = i - 1

main :: IO ()
main = do
  vector <- withSystemRandom $ \gen -> do
    vector <- V.unsafeThaw $ V.enumFromTo 1 (20 :: Int)
    shuffleM gen (M.length vector) vector
    V.unsafeFreeze vector
  print vector
