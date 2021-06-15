#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
import Data.Typeable (cast)
import RIO

data Parent = Parent1 Child1 | Parent2 Child2
  deriving (Show, Typeable)
instance Exception Parent

data Child1 = Child1
  deriving (Show, Typeable)
instance Exception Child1 where
  toException = toException . Parent1
  fromException se =
    case fromException se of
      Just (Parent1 c) -> Just c
      _ -> Nothing

data Child2 = Child2
  deriving (Show, Typeable)
instance Exception Child2 where
  toException = toException . Parent2
  fromException se =
    case fromException se of
      Just (Parent2 c) -> Just c
      _ -> Nothing

main :: IO ()
main = runSimpleApp $ do
  throwIO Child1 `catch` (\(_ :: SomeException) -> logInfo "Caught it")
  throwIO Child1 `catch` (\(_ :: Parent) -> logInfo "caught it again")
  throwIO Child1 `catch` (\(_ :: Child1) -> logInfo "one more catch")
  throwIO Child1 `catch` (\(_ :: Child2) -> logInfo "missed")

