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
import Control.Monad (unless, forM_)

files :: [FilePath]
files = ["pr01.hs", "pr02.hs", "pr03.hs"]

withBinaryFiles :: [FilePath] -> IOMode -> ([Handle] -> IO a) -> IO a
withBinaryFiles fps mode inner =
  loop fps id
  where
    loop [] front = inner $ front []
    loop (x:xs) front =
      withBinaryFile x mode $ \h ->
      loop xs (front . (h:))

main :: IO ()
main = run 3000 $ \_req send -> withBinaryFiles files ReadMode $ \hs ->
  send $ responseStream
    status200
    [("Content-Type", "text/plain")]
    $ \chunk _flush -> forM_ hs $ \h -> fix $ \loop -> do
      bs <- B.hGetSome h 4096
      unless (B.null bs) $ do
        chunk $byteString bs
        loop
