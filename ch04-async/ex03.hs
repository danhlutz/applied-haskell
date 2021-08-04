#!/usr/bin/env stack
-- stack script --resolver lts-12.21
import Control.Concurrent (threadDelay)
import Control.Concurrent.Async
import Control.Exception (bracket, SomeException)
import Control.Monad
import Say

talker :: String -> IO ()
talker str = forever $ do
  sayString str
  threadDelay 500000

getResult :: IO Int
getResult = do
  sayString "Doing some big computation ... "
  threadDelay 2000000
  sayString "Done!"
  return 42

withAsync' :: IO a -> (Async a -> IO b) -> IO b
withAsync' action = bracket (async action) cancel

withAsync'' :: IO a -> (Async a -> IO b) -> IO b
withAsync'' action op = do
  async1 <- async action
  res <- op async1
  cancel async1
  return res

waitCatch' :: Async a -> IO (Either SomeException a)
waitCatch' thread = do
  res <- poll thread
  case res of
    Nothing -> waitCatch' thread
    Just x -> return x

main :: IO ()
main = do
  async1 <- async $ talker "async"
  withAsync'' (talker "withAsync") $ \async2 -> do
    async3 <- async getResult

    res <- poll async3
    case res of
      Nothing -> sayString "getResult still running"
      Just (Left e) -> sayString $ "getResult failed: " ++ show e
      Just (Right x) -> sayString $ "getResult finished 1: " ++ show x

    res <- waitCatch' async3
    case res of
      Left e -> sayString $ "getResult failed: " ++ show e
      Right x -> sayString $ "getResult finished 2: " ++ show x

    res <- wait async3
    sayString $ "getResult finished 3: " ++ show res

  sayString "withAsync talker should be dead, but not async"
  threadDelay 2000000

  sayString "now killing async talker"
  cancel async1

  threadDelay 2000000
  sayString "goodbye!"
