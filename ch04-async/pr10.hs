#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Applicative ((<|>))
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async
import Control.Concurrent.STM
import Say

getResult1 :: IO Int
getResult1 = do
  sayString "Doing Some big computation"
  threadDelay 2000000
  sayString "Done!"
  return 42

getResult2 :: IO Int
getResult2 = do
  sayString "Doing Some big computation"
  threadDelay 1000000
  sayString "Done!"
  return 41

main :: IO ()
main = do
  res <- withAsync getResult1 $ \a1 ->
         withAsync getResult2 $ \a2 ->
         atomically $ waitSTM a1 <|> waitSTM a2
  sayString $ "getResult finished: " ++ show res
