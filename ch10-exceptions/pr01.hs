#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

data MyException = MyException
  deriving (Show, Typeable)
instance Exception MyException

main :: IO ()
main = runSimpleApp $ do
  logInfo "This will be called"
  throwIO MyException
  logInfo "This will never be called"
