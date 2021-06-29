#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Concurrent
import Control.Concurrent.Async
import Control.Exception

counter :: IO a
counter =
  let loop i = do
        putStrLn $ "counter: " ++ show i
        threadDelay 100000
        loop $! i + 1
  in loop 1

withCounter :: IO a -> IO a
withCounter inner = do
  res <- race counter inner
  case res of
    Left x -> assert False x
    Right x -> return x

main :: IO ()
main = do
  putStrLn "Before withCounter"
  threadDelay 2000000
  withCounter $ do
    threadDelay 2000000
    putStrLn "inside withCounter"
    threadDelay 2000000
  threadDelay 2000000
  putStrLn "After withCounter"
  threadDelay 2000000
  putStrLn "Exciting!"
