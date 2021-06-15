#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import Data.Typeable (cast)
import RIO

data MyException = MyException
  deriving (Show, Typeable)
instance Exception MyException where
  toException e = SomeException e
  fromException (SomeException e) = cast e

main :: IO ()
main = runSimpleApp $
  throwIO MyException `catch` \MyException ->
  logInfo "I caught my own exception!"
