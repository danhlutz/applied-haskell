#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

displayAge maybeAge =
  case maybeAge of
    Nothing -> putStrLn "invalid input"
    Just age -> putStrLn $ "In that year, you will be " ++ show age

yearDiff f b = f - b

main = do
  putStrLn "Please enter your birth year"
  birthYearString <- getLine
  putStrLn "Please enter some year in the future"
  futureYearString <- getLine
  let maybeAge = do
        futureYear <- readMaybe futureYearString
        birthYear <- readMaybe birthYearString
        return $
          if futureYear < birthYear
            then yearDiff birthYear futureYear
            else yearDiff futureYear birthYear
  displayAge maybeAge
