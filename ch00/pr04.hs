#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

displayAge maybeAge =
  case maybeAge of
    Nothing -> putStrLn "Invalid input"
    Just age -> putStrLn $ "In that year, you will be " ++ show age

yearDiff futureYear birthYear = futureYear - birthYear

main = do
  putStrLn "Please enter your birth year"
  birthYearString <- getLine
  putStrLn "Please enter a year in the future"
  futureYearString <- getLine
  let maybeAge = yearDiff
                 <$> readMaybe futureYearString
                 <*> readMaybe birthYearString
  displayAge maybeAge
