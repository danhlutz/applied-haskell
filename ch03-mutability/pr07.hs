#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Control.Concurrent.Async
import Control.Concurrent.STM
import Control.Concurrent.STM.TBMQueue
import Control.Exception (finally)
import Control.Monad (forever, void)
import qualified Data.ByteString.Lazy as BL
import Data.Foldable (for_)
import Network.HTTP.Simple

main :: IO ()
main = do
  queue <- newTBMQueueIO 16
  concurrently_
    (fillQueue queue `finally` atomically (closeTBMQueue queue))
    (replicateConcurrently_ 8 (drainQueue queue))

fillQueue :: TBMQueue (String, String) -> IO ()
fillQueue queue = do
  contents <- getContents
  for_ (lines contents) $ \line ->
    case words line of
      [url, file] -> atomically $ writeTBMQueue queue (url, file)
      _ -> error $ "Invalid line " ++ show line

drainQueue :: TBMQueue (String, String) -> IO ()
drainQueue queue = loop
  where
    loop = do
      mnext <- atomically $ readTBMQueue queue
      case mnext of
        Nothing -> return ()
        Just (url, file) -> do
          req <- parseRequest url
          res <- httpLBS req
          BL.writeFile file $ getResponseBody res
