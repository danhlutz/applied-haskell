#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}

import Data.Binary
import Data.Text

data Transaction =
  Txn { account :: Text, amount :: Float }
  deriving Show

instance Binary Transaction where
  put (Txn acct amt) = do
    put acct
    put amt

  get = do
    acct <- get
    amt <- get
    return $ Txn acct amt

main :: IO ()
main = do
  let bytes = encode (Txn { account = "Cash", amount = 0} )
  putStrLn $ "Encode: " ++ show bytes
  putStrLn $ "Decode: " ++ show (decode bytes :: Transaction)
