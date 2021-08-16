#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid ((<>))
import Data.ByteString.Builder (Builder, toLazyByteString)

main :: IO ()
main = print (toLazyByteString ("Hello " <> "there " <> "world" :: Builder))
