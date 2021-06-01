#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc

import Text.Read (readMaybe)

displayAge maybeAge =
  case maybeAge of
    Nothing -> putStrLn "invalid year"
    Just age -> putStrLn $ "In 2021, you will be " ++ show age

yearToAge year = 2021 - year

main = do
  putStrLn "Please enter your birth year"
  yearString <- getLine
  let maybeAge = do
        yearInteger <- readMaybe yearString
        return $ yearToAge yearInteger
  displayAge maybeAge
