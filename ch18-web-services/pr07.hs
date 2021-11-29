#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import Data.Aeson

main :: IO ()
main = run 3000 $ \_req send -> send $ responseBuilder
  status200
  [("Content-Type", "application/json")]
  $ fromEncoding $ toEncoding $ object
    [ "foo" .= (5 :: Int)
    , "bar" .= True]
