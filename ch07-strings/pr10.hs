#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid ((<>))
import qualified Data.Text.IO as TIO

main :: IO ()
main = do
  TIO.putStrLn "what is your name? "
  name <- TIO.getLine
  TIO.putStrLn $ "Hello " <> name
