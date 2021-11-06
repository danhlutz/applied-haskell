#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}

import Data.Binary
import Data.Text
import GHC.Generics (Generic)

data Transaction =
  Txn { account :: Text, amount :: Float }
  deriving (Generic, Show)

instance Binary Transaction

main :: IO ()
main = do
  let bytes = encode (Txn { account = "Cash", amount = 0} )
  putStrLn $ "Encode: " ++ show bytes
  putStrLn $ "Decode: " ++ show (decode bytes :: Transaction)
