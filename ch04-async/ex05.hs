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
getResult2 = error "error!"

getResult3:: IO Int
getResult3 = do
  sayString "Doing Some big computation"
  threadDelay 1000000
  sayString "Done!"
  return 43

main :: IO ()
main = do
  res <- withAsync getResult3 $ \a1 ->
         withAsync getResult1 $ \a2 ->
         atomically $ pollTillDone a1 a2
  sayString $ "getResult finished: " ++ show res
  where
    pollTillDone a1 a2 = do
      res1 <- pollSTM a1
      res2 <- pollSTM a2
      case (res1, res2) of
        (Just (Left _), Just (Left _)) -> error "no result"
        (_, Just (Right y)) -> return y
        (Just (Right x), _) -> return x
        _ -> pollTillDone a1 a2
