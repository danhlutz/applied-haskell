#!/usr/bin/env stack
-- stack --resolver lts-16.27 script
{-# LANGUAGE OverloadedStrings #-}
import System.Process.Typed

main :: IO ()
main = do
  runProcess (proc "cat" ["/etc/hosts"]) >>= print

  runProcess (shell "cat /etc/hosts >&2 && false") >>= print
