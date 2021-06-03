#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

displayAge maybeAge =
  case maybeAge of
    Nothing -> putStrLn "invalid input"
    Just age -> putStrLn $ "In that year, you will be " ++ show age

yearDiff futureYear birthYear
  | futureYear < birthYear = birthYear - futureYear
  | otherwise = futureYear - birthYear

main
    | yearDiff 5 6 == 1 = putStrLn "Correct!"
    | otherwise = putStrLn "try again"
