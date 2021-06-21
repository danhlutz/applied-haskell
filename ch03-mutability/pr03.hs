#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE NoImplicitPrelude #-}
import RIO
import Prelude (print)

main :: IO ()
main = do
  fib1 <- newURef (0 :: Int)
  fib2 <- newURef 1

  replicateM_ 1000000 $ do
    x <- readURef fib1
    y <- readURef fib2
    writeURef fib1 y
    writeURef fib2 (x + y)

  readURef fib2 >>= print
