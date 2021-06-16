#!/usr/bin/env stack
-- stack --resolver lts-12.21 script --optimize
import Data.IORef
import Control.Concurrent.Async (mapConcurrently_)

main :: IO ()
main = do
  ref <- newIORef (0 :: Int)
  modifyIORef ref (+ 1)
  readIORef ref >>= print
  writeIORef ref 2
  readIORef ref >>= print

  --race condition
  let raceIncr = modifyIORef' ref (+ 1)
  writeIORef ref 0
  mapConcurrently_ id $ replicate 10000 raceIncr
  readIORef ref >>= print

  -- no race condition
  let noRaceIncr = atomicModifyIORef' ref (\x -> (x+1,()))
  writeIORef ref 0
  mapConcurrently_ id $ replicate 10000 noRaceIncr
  readIORef ref >>= print
