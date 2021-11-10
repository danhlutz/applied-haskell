#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Data.Aeson (withObject)
import Data.Text (Text)
import Data.Yaml
import Data.Yaml.Config

data Config = Config
  { awsSecret    :: !Text
  , homeResponse :: !Text
  } deriving Show
instance FromJSON Config where
  parseJSON = withObject "Config" $ \o -> Config
    <$> o .: "aws-secret"
    <*> o .: "home-response"

main :: IO ()
main = do
  config <- loadYamlSettingsArgs [] useEnv
  print (config :: Config)
