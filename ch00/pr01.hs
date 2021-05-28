#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

main = do
  putStrLn "Please enter your birth year"
  yearString <- getLine
  case readMaybe yearString of
    Nothing -> putStrLn "invalid year"
    Just year -> putStrLn $ "In 2021, you will be: " ++ show (2021 - year)
