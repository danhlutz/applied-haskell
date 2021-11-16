#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = runProcess_ $ setStdin "Hello World!\n" "cat"
