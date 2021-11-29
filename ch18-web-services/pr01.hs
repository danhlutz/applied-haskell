#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Network.HTTP.Types

main :: IO ()
main = run 3000 $ \req send -> send $ responseBuilder
  status200
  (case lookup "marco" $ requestHeaders req of
     Nothing -> []
     Just val -> [("Polo", val)])
  "Hello WAI!"
