#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

main = do
  print (readMaybe "1980" :: Maybe Integer)
  print (readMaybe "hello" :: Maybe Integer)
  print (readMaybe "2000" :: Maybe Integer)
  print (readMaybe "two-thousand" :: Maybe Integer)
