#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text.Encoding as TE
import qualified Data.Text.Encoding.Error as TEE

main :: IO ()
main = do
  let bs = "Invalid UTF8 sequence\254\253\252"
  print $ TE.decodeUtf8With TEE.lenientDecode bs
