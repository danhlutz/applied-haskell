#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString.Lazy.Char8 as L8
import           Network.HTTP.Client (newManager)
import           Network.HTTP.Client.TLS (tlsManagerSettings)
import           Network.HTTP.Simple

main :: IO ()
main = do
  manager <- newManager tlsManagerSettings
  let request = setRequestManager manager "https://httpbin.org/get"
  response <- httpLBS request

  putStrLn $ "Status: " ++ show (getResponseStatusCode response)
  print $ getResponseHeader "Content-Type" response
  L8.putStrLn $ getResponseBody response
