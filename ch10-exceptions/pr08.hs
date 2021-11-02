#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp $ do
  res1 <- try $ throwString "This will be caught"
  logInfo $ displayShow (res1 :: Either StringException ())

  res2 <- try $ pure ()
  logInfo $ displayShow (res2 :: Either StringException ())

  res3 <- try $ throwString "This will be caught"
  logInfo $ displayShow (res3 :: Either StringException ())

  res4 <- try $ throwString "This will *not* be caught"
  logInfo $ displayShow (res4 :: Either IOException ())
