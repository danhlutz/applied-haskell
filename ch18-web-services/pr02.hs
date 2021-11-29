#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import qualified Data.ByteString.Lazy as BL
import System.IO

main :: IO ()
main = run 3000 $ \_req send -> withBinaryFile "pr01.hs" ReadMode $ \h -> do
  lbs <- BL.hGetContents h
  send $ responseLBS
    status200
    [("Content-Type", "text/plain")]
    lbs
