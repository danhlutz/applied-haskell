module Main where

import Conduit

average :: Monad m => ConduitM Int o m Double
average =
  divide <$> foldlC add (0,0)
  where
    divide (t,c) = fromIntegral t/c
    add (t,c) x  = (t + x, c + 1)

main :: IO ()
main = print $ runConduitPure $ enumFromToC 1 1000000 .| average
