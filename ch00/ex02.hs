#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc

returnMaybe = Just

main
    | returnMaybe "Hello" == Just "Hello" = putStrLn "Correct!"
    | otherwise = putStrLn "Incorrect"
