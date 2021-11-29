#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import qualified Data.ByteString as B
import Data.ByteString.Builder (byteString)
import System.IO
import Data.Function (fix)
import Control.Monad (unless)

main :: IO ()
main = run 3000 $ \_req send -> withBinaryFile "pr04.hs" ReadMode $ \h ->
  send $ responseStream
    status200
    [("Content-Type", "text/plain")]
    $ \chunk _flush -> fix $ \loop -> do
      bs <- B.hGetSome h 4096
      unless (B.null bs) $ do
        chunk $byteString bs
        loop
