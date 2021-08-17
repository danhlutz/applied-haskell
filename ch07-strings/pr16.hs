#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
{-# LANGUAGE OverloadedStrings #-}
import qualified Data.ByteString as B
import qualified Data.ByteString.Builder as BB
import System.IO (stdout)
import Data.Monoid ((<>))

fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

main :: IO ()
main = BB.hPutBuilder stdout $ foldr
  (\i rest -> BB.intDec i <> "\n" <> rest)
  mempty
  (take 5 fibs)
