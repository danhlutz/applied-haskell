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
import Control.Monad.Trans.Resource
import Control.Monad.IO.Class
import UnliftIO.Exception (bracket)

files :: [FilePath]
files = ["pr01.hs", "pr02.hs", "pr03.hs"]

main :: IO ()
main = run 3000 $ \_req send ->
  bracket createInternalState closeInternalState $ \is ->
  send $ responseStream
  status200
  [("Content-Type","text/plain")]
  $ \chunk _flush -> runInternalState ( forM_ files $ \file -> do
      (releaseKey, h) <- allocate
        (openBinaryFile file ReadMode)
        hClose
      liftIO $ fix $ \loop -> do
        bs <- B.hGetSome h 4096
        unless (B.null bs) $ do
          chunk $ byteString bs
          loop
      release releaseKey) is
 
