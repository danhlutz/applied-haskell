#!/usr/bin/env stack
-- stack script --resolver lts-12.21
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson
import Data.Text (Text)

data Person = Person { name :: Text, age :: Int } deriving Show

instance FromJSON Person where
  parseJSON (Object v) = Person <$> v .: "name" <*> v.: "age"
  parseJSON _ = mempty

instance ToJSON Person where
  toJSON (Person name age) = object ["name" .= name, "age" .= age]

main :: IO ()
main = do
  putStrLn $ "Encode: " ++ show (encode (Person { name = "Joe", age = 12 }))
  putStrLn $ "Decode: " ++
    show (decode "{ \"name\": \"Joe\", \"age\": 12}" :: Maybe Person)
