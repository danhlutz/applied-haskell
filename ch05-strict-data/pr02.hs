#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import Data.Foldable (foldl')
import UnliftIO.Exception (pureTry)

data Foo = Foo Int deriving Show

data Bar = Bar !Int deriving Show

newtype Baz = Baz Int deriving Show

main :: IO ()
main = do
  print $ pureTry $ case Foo undefined of
    Foo _ -> "FOO Hello world"
  print $ pureTry $ case Bar undefined of
    Bar _ -> "BAR Hello world"
  print $ pureTry $ case Baz undefined of
    Baz _ -> "BAZ Hellow world"
