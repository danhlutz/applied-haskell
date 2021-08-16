#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid ((<>))
import Data.Text.Lazy.Builder (Builder, toLazyText)

main :: IO ()
main = print (toLazyText ("Hello " <> "there " <> "world" :: Builder))
