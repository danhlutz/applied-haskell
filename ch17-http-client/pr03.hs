#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import           Data.Aeson           (Value)
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple

main :: IO ()
main = do
  request <- parseRequest "POST http://httpbin.org/post"
  response <- httpJSON request

  putStrLn $ "Status code: " ++ show (getResponseStatusCode response)
  print $ getResponseHeader "Content-Type" response
  S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)
