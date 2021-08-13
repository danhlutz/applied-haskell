#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Data.ByteString (ByteString)
import qualified Data.ByteString as S
import qualified Data.ByteString.Char8 as S8
import Data.Text (Text)
import qualified Data.Text as T

main :: IO ()
main = do
  print (S8.pack "this is now a bytestring" :: ByteString)
  print (T.pack "This is no a Text" :: Text)
