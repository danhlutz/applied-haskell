#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Data.Foldable (foldl')

data Foo = Foo Int deriving Show

data Bar = Bar !Int deriving Show

newtype Baz = Baz Int deriving Show

main :: IO ()
main = do
  print $ foldl' (\(Foo total) x -> Foo (total + x)) (Foo 0) [1..1000000]
  print $ foldl' (\(Bar total) x -> Bar (total + x)) (Bar 0) [1..1000000]
  print $ foldl' (\(Baz total) x -> Baz (total + x)) (Baz 0) [1..1000000]
