{-# LANGUAGE BangPatterns #-}
module Practice where

data List a = Cons !a (List a) | Nil

main = Cons undefined (Cons undefined Nil) `seq` putStrLn "hello world"
