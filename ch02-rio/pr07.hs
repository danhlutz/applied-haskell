#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
import RIO

main :: IO ()
main = runSimpleApp sayHello

sayHelloRIO :: HasLogFunc env => RIO env ()
sayHelloRIO = logInfo "Hello world!"

sayHello :: (MonadReader env m, MonadIO m, HasLogFunc env) => m ()
sayHello = liftRIO sayHelloRIO
