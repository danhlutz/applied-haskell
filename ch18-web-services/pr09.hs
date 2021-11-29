#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Network.Wai
import Network.Wai.Conduit
import Network.Wai.Handler.Warp
import Network.HTTP.Types
import Data.Aeson
import Data.Aeson.Parser (json)
import Data.Aeson.Types
import Data.Conduit
import Data.Conduit.Attoparsec (sinkParser)

newtype Body = Body Int

instance ToJSON Body where
  toJSON (Body i) = object ["hello" .= i]
instance FromJSON Body where
  parseJSON = withObject "Body" $ \o -> Body <$> o .: "hello"

main :: IO ()
main = run 3000 $ \req send -> do
  val <- runConduit
       $ sourceRequestBody req
      .| sinkParser json
  let Success (Body i) = fromJSON val
  send $ responseBuilder
    status200
    [("Content-Type", "application/json")]
    $ fromEncoding $ toEncoding $ Body $ i + 1
