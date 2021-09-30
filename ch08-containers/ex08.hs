#!/usr/bin/env stack
-- stack --resolver lts-12.21 script
import           Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as HashMap
import           Data.List (sort)

type Name = String
type StudentId = Int
type Score = Double

students :: HashMap Name StudentId
students = HashMap.fromList
  [ ("Alice", 1)
  , ("Bob", 2)
  , ("Charlie", 3)
  ]

scores :: HashMap Name Score
scores = HashMap.singleton "Bob" 90.4

noTestScore :: [Name]
noTestScore = filter noScore (fst <$> HashMap.toList students)
  where
    noScore :: String -> Bool
    noScore key = not $ HashMap.member key scores

main :: IO ()
main = do
  putStrLn "The following students have not taken the test"
  mapM_ putStrLn $ sort noTestScore
