#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
import RIO
import Test.Hspec

-- use mapConcurrently_
rc1 :: Int -> IO () -> IO ()
rc1 x thr = mapConcurrently_ (const thr) [1..x]

-- use Concurrently
rc2 :: Int -> IO () -> IO ()
rc2 x thr = runConcurrently $ replicateM_ x (Concurrently thr)

-- use concurrently_
rc3 :: Int -> IO () -> IO ()
rc3 = undefined

-- use withAsync
rc4 :: Int -> IO () -> IO ()
rc4 = undefined

main :: IO ()
main = hspec $ do
  let rcs =
        [ ("the original", replicateConcurrently_)
        , ("using mapConcurrently_", rc1)
        , ("using Concurrently", rc2)
        , ("using concurrently_", rc3)
        , ("using withAsync", rc4) ]
  for_ rcs $ \(name, rc) -> it name $ do
    resVar <- newTVarIO 0
    rc 10 $ atomically $ modifyTVar' resVar (+ 1)
    readTVarIO resVar `shouldReturn` 10
