#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import Data.Text
import GHC.Generics

data Person = Person { name :: Text, age :: Int } deriving (Generic, Show)

instance FromJSON Person
instance ToJSON Person

main :: IO ()
main = do
  putStrLn $ "Encode: " ++ show (encode (Person { name = "Joe", age = 12 }))
  putStrLn $ "Decode: " ++
    show (decode "{ \"name\": \"Joe\", \"age\": 12}" :: Maybe Person)
