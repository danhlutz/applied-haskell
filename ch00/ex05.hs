#!/usr/bin/env stack
-- stack --resolver lts-7.14 --install-ghc runghc
import Text.Read (readMaybe)

displayAge maybeAge =
  case maybeAge of
    Nothing -> putStrLn "invalid input"
    Just age -> putStrLn $ "In that year, you will be " ++ show age

yearDiff futureYear birthYear = futureYear - birthYear

myHelper f a b
  | a < b = f b a
  | otherwise = f a b

main
    | myHelper yearDiff 6 5 == 1 = putStrLn "Correct!"
    | otherwise = putStrLn "try again"
