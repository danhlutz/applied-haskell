#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import           Data.Aeson
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple

data Person = Person String Int
instance ToJSON Person where
  toJSON (Person n a) = object
    [ "name" .= n
    , "age" .= a ]

people :: [Person]
people = [Person "Alice" 30, Person "Bob" 35, Person "Charlie" 40]

main :: IO ()
main = do
  Yaml.encodeFile "people.yaml" people

  let request = setRequestBodyFile "people.yaml"
              $ setRequestHeader "Content-Type" ["application/x-yaml"]
              "PUT https://httpbin.org/put"
  response <- httpJSON request

  putStrLn $ "Status code: " ++ show (getResponseStatusCode response)
  print $ getResponseHeader "Content-Type" response
  S8.putStrLn $ Yaml.encode (getResponseBody response :: Value)
