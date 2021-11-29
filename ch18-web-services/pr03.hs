#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types

main :: IO ()
main = run 3000 $ \req send ->
  case pathInfo req of
    [] -> send $ responseBuilder
      status303
      [("Location", "/home")]
      "Redirecting"
    ["home"] -> send $ responseBuilder
      status200
      [("Content-Type", "text-plain")]
      "This is the home route"
